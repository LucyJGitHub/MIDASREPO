     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cashier TCP/IP branch monitor')               *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE004502 - Midas Cashier TCP/IP Branch Monitor               *
      *                                                               *
      *  This program is based on RE4402 and both version should be   *
      *  maintained at the same level.                                *
      *                                                               *
      *  Function:  This program will be evoked automatically during  *
      *  (I/C)      Input Cycle by each remote Branch Monitor job     *
      *             starting at the AS/400.  It will provide the      *
      *             communications link between the Midas system      *
      *             on the AS/400 and the remote branch monitor by    *
      *             opening  a conversation with the requester.  This *
      *             function will provide monitoring of the status of *
      *             the remote branch.  It will also provide the      *
      *             communications to download the start of day       *
      *             information for accounts and stopped cheques      *
      *             before the 'Open Branch' process can be run.  It  *
      *             will also handle 'trickle feed' communications    *
      *             throughout the day for transactions performed     *
      *             outside of the account branch and for any account *
      *             maintenance performed e.g. holds placed, accounts *
      *             opened and closed and account referral conditions.*
      *  Author: Alain Differdange                                    *
      *  Called By: REC4502 - CI Branch Monitor Control               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 213974             Date 28Mar03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 189857             Date 31May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CRT004  *CREATE    Date 06Jun00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  213974 - Account type/Sub-type blanked after A/C Maintenance.*
      *  189857 - Allow for a download of an other branches details   *
      *  CRT004 - Cashier Midas TCP/IP interface.                     *
      *                                                               *
      *****************************************************************
      /EJECT
     FRECIADL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      **  CS Account Details Download by branch, a/c no
      *
     FRECISCL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      **  CS Stopped Cheques Extract by branch, a/c no
      *
     FRECITFL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      **  CS Trickle Feed Details by branch
      *
     FRECITFL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     RENAME(RECITFD0:RECITFD1)
      **  CS Trickle Feed Dtls by branch, a/c, trkl feed type, status
      *
     FSDBRCHL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      **  SD Branch Codes Update
      *
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                  ----------------------                       *
      *                                                               *
      *                                                               *
      *       31         End of File for LF/RECIADL0.                 *
      *       32         End of File for LF/RECISCL0.                 *
      *       33         End of File for LF/RECITFL0                  *
      *       34         End of File for LF/RECITFL1
      *       41         Chain fail                                   *
      *       55         DLTDTAARA fail on QCMDEXC                    *
      *       60         SHUTDOWN Indicator                           *
      *                                                               *
      *       80-89      Standard RTS subroutines                     *
      *                                                               *
      *       90-99      Standard MIDAS subroutines                   *
      *                                                               *
      *                                                               *
      *       U6         System error                                 *
      *       U7+U8      Database error occurs                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  DBERR  - Database Error Handling.                            *
      *  INIT   - Initialisation.                                     *
      *  *PSSR  - Program Error.                                      *
      *                                                               *
      *  ACDWNL - Account Download Processing                         *
      *  CHKBRS - Check Branch Status                                 *
      *  UPDBRS - Update Branch Status                                *
      *  DOWNLD - Data Download Processing                            *
      *  INCTRK - Incomplete Trickle Feed Processing                  *
      *  RCVDET - Detail Instruction Received on ICF Read.            *
      *  RCVDTQ - Receive Dataqueue Processing                        *
      *  RCVSAC - Branch Status Acknowledgement on ICF Read           *
      *  SCDWNL - Stopped Cheques Download Processing                 *
      *  SNDSUS - Send 'SUSP'end msg to Host Monitor                  *
      *  TRKLFD - Trickle Feed Processing                             *
      *  ZDATE2 - Convert Midas Day No. to a date format              *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      **  Array containing Copyright statement.
      *
     D ALC             S             80    DIM(1) CTDATA PERRCD(1)                               118
      **  Array containing ALCOBJ command for QCMDEXEC.                   118737
      *                                                                   118737
      *
     D PSDS           SDS
      **  Program status data structure.
      *
     D  ZAPGM            *PROC
     D  WSID                 244    246
     D  WSID2                245    246
     D  WSJOB                244    253
     D  USRID                254    263
     D  JNUMBR               264    269  0
     D  JOBNUM               264    269
      *
     D DATR            DS            29
      **  Data structure for message data returned on Dataqueue from RBA.
      *
     D  R#BRCA                 1      3
     D  R#ACNT                 4     13
     D  R#TFTP                14     15
     D  R#TFSQ                16     21
     D  R#TFST                22     22
     D  R#SUSP                 1      4
     D  R#LOCK                 1      9
     D  R#DLDB                 1      4                                          189857
     D  R#OTHB                 5      7                                          189857
      **  DLDB/OTHB For download of a database to another branch                 189857
      *
     D DSACNT        E DS                  EXTNAME(RECIADL0)
      **  Data structure for a/c details download record
      *
     D DSSTCQ        E DS                  EXTNAME(RECISCL0)
      **  Data structure for stopped chqs download record
      *
     D CONECT          DS            17
      **  Data structure for initial connection
      *
     D  C#BRCA                 1      4
     D***********************************     5  14 C#USID                118566
     D***********************************    15  17 C#UNID                118566
     D  C#USID                 5      8                                         118566
     D  C#UNID                 9     11                                         118566
      *
     D FLDWLD          DS            10
      **  Data structure for Start Database Download
      *
     D  D#DWLD                 1      4
     D  D#DATE                 5     10
      *
     D FSTATR          DS            87
      **  Data struc for Branch Status Request
      *
     D  RQSTAT                 1      4
     D  RQHMSS                 5      5
     D  RQHMSI                 6      9
     D  RQHSMS                10     87
      *
     D FSTATA          DS            10
      **  Data struc Branch Status Acknowledgement
      *
     D  ACSTAT                 1      4
     D  ACBRST                 5      5
     D  ACABRT                 6      6
     D  ACVERS                 7      9
     D  ACBLNK                10     10                                         120072
      *
     D FLDWAC          DS          6097
      **  Data structure for A/c Download to ICF file
      *
     D  DATYPE                 1      4
     D  DARCNT                 5      6  0
     D  DAMRDT                 7      7
     D  DADB1                  8    210
     D  DADB2                211    413
     D  DADB3                414    616
     D  DADB4                617    819
     D  DADB5                820   1022
     D  DADB6               1023   1225
     D  DADB7               1226   1428
     D  DADB8               1429   1631
     D  DADB9               1632   1834
     D  DADB10              1835   2037
     D  DADB11              2038   2240
     D  DADB12              2241   2443
     D  DADB13              2444   2646
     D  DADB14              2647   2849
     D  DADB15              2850   3052
     D  DADB16              3053   3255
     D  DADB17              3256   3458
     D  DADB18              3459   3661
     D  DADB19              3662   3864
     D  DADB20              3865   4067
     D  DADB21              4068   4270
     D  DADB22              4271   4473
     D  DADB23              4474   4676
     D  DADB24              4677   4879
     D  DADB25              4880   5082
     D  DADB26              5083   5285
     D  DADB27              5286   5488
     D  DADB28              5489   5691
     D  DADB29              5692   5894
     D  DADB30              5895   6097
      *
     D FLDWSC          DS          4307
      **  Data structure for Stopped Chqs Download to ICF file
      *
     D  DQTYPE                 1      4
     D  DQRCNT                 5      6  0
     D  DQMRDT                 7      7
     D  DQDB1                  8     93
     D  DQDB2                 94    179
     D  DQDB3                180    265
     D  DQDB4                266    351
     D  DQDB5                352    437
     D  DQDB6                438    523
     D  DQDB7                524    609
     D  DQDB8                610    695
     D  DQDB9                696    781
     D  DQDB10               782    867
     D  DQDB11               868    953
     D  DQDB12               954   1039
     D  DQDB13              1040   1125
     D  DQDB14              1126   1211
     D  DQDB15              1212   1297
     D  DQDB16              1298   1383
     D  DQDB17              1384   1469
     D  DQDB18              1470   1555
     D  DQDB19              1556   1641
     D  DQDB20              1642   1727
     D  DQDB21              1728   1813
     D  DQDB22              1814   1899
     D  DQDB23              1900   1985
     D  DQDB24              1986   2071
     D  DQDB25              2072   2157
     D  DQDB26              2158   2243
     D  DQDB27              2244   2329
     D  DQDB28              2330   2415
     D  DQDB29              2416   2501
     D  DQDB30              2502   2587
     D  DQDB31              2588   2673
     D  DQDB32              2674   2759
     D  DQDB33              2760   2845
     D  DQDB34              2846   2931
     D  DQDB35              2932   3017
     D  DQDB36              3018   3103
     D  DQDB37              3104   3189
     D  DQDB38              3190   3275
     D  DQDB39              3276   3361
     D  DQDB40              3362   3447
     D  DQDB41              3448   3533
     D  DQDB42              3534   3619
     D  DQDB43              3620   3705
     D  DQDB44              3706   3791
     D  DQDB45              3792   3877
     D  DQDB46              3878   3963
     D  DQDB47              3964   4049
     D  DQDB48              4050   4135
     D  DQDB49              4136   4221
     D  DQDB50              4222   4307
      *
     D FLTFAO          DS           149
      **  Data structure for Trickle Feed A/c Open format
      *
     D  TOTYPE                 1      4
     D  TOACNT                 5     17
     D  TOEXAC                18     37
     D  TOCNAM                38     72
     D  TOANAM                73     87
     D  TOSTRC                88     88
     D  TOCCY                 89     91
     D  TOARFN                92    126
     D  TOPXTC               127    129
     D  TOSXTC               130    132
     D  TOARSN               133    147
     D  TOCTYP               148    149
      *
     D*FLTFAM***       DS           157                                                       213974
     D FLTFAM          DS           159                                                       213974
      **  Data structure for Trickle Feed A/c Maintenance fmt
      *
     D  TMTYPE                 1      4
     D  TMACNT                 5     17
     D  TMCNAM                18     52
     D  TMANAM                53     67
     D  TMSTRC                68     68
     D  TMCCY                 69     71
     D  TMRL                  72     72
     D  TMRLC                 73     73
     D  TMRLD                 74     74
     D  TMADL                 75     75
     D  TMABL                 76     76
     D  TMADM                 77     77
     D  TMACL                 78     78
     D  TMSGO                 79     79
     D  TMR9                  80     80
     D  TMR10                 81     81
     D  TMARFN                82    116
     D  TMPXTC               117    119
     D  TMSXTC               120    122
     D  TMARSN               123    137
     D  TMEXA                138    157
     D  TMCTYP               158    159                                                       213974
      *
     D FLTFAD          DS            37
      **  Data structure for Trickle Feed A/c Delete fmt
      *
     D  TDTYPE                 1      4
     D  TDACNT                 5     17
     D  TDEXA                 18     37
      *
     D FLTFBL          DS            85
      **  Data structure for Trickle Feed Balance Change fmt
      *
     D  TBTYPE                 1      4
     D  TBACNT                 5     17
     D  TBAVB                 18     34
     D  TBFDC                 35     50
     D  TBDTT                 51     65
     D  TBEXA                 66     85
      *
     D FLTFFC          DS             5
      **  Data structure for Trickle Feed Funds Cleared fmt
      *
     D  TCTYPE                 1      4
     D  TCSTAT                 5      5
      *
     D FLTFSU          DS            90
      **  Data structure for Trickle Feed Stop Maintenance fmt
      *
     D  TUTYPE                 1      4
     D  TUACNT                 5     17
     D  TUREF                 18     22
     D  TU1SN                 23     38
     D  TULSN                 39     54
     D  TUSAM                 55     70
     D  TUEXA                 71     90
      *
     D FLTFSD          DS            42
      **  Data structure for Trickle Feed Stop Deletion fmt
      *
     D  TZTYPE                 1      4
     D  TZACNT                 5     17
     D  TZREF                 18     22
     D  TZEXA                 23     42
      *
     D LDA             DS           256
      **  Local Data Area to identify database errors.
      *
     D  PBRCA                  1      3
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBLOT                134    183
      *
     D MPHAS           DS             1
      **  Module Phase of Day Data area.
      *
     D  WPHAS                  1      1
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Bank Details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      **  Branch Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      **  Switchable SARs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Second DS for access programs, long data structure
      *
     D                 DS                                                       118737
      **  DS for ALCOBJ command for QCMDEXEC                              118737
      *                                                                   118737
     D  @CMD                   1     80                                         118737
     D  @BRC                  19     21                                         118737
      **************************************************************************
      **  Socket Functions Prototype Definitions (Service Program SP670RE01)
      *
     D opn_tcp         pr            10i 0
 
     D bnd_tcp         pr            10i 0
     d                               10i 0 Const
     d                               10i 0 Const
     d                               10i 0 Const
 
     D con_tcp         pr            10i 0
     d                               10i 0 Const
     d                               30
     d                                2  0 Const
     d                                4  0 Const
     D sel_tcp         pr            10i 0
     d  socket                       10i 0
     d  time_sec                     10i 0
     d  wait_act                     10i 0
     d  rc                           10i 0
 
     D snd_tcp         pr            10i 0
     d                               10i 0 Const
     d                             9911
 
     D rcv_tcp         pr            10i 0
     d                               10i 0 Const
     d                             9911
 
     D cls_tcp         pr            10i 0
     d                               10i 0 Const
 
      **  Other variables
      *
     D ScktNum         S             10I 0
     D RetCode         S             10I 0
     D Header          S             11
     D Sbuffer         S           9911
     D Rbuffer         S           9911
     D MsgType         S              3
     D Risc            S             30
     d time_sec        S             10i 0
     d wait_act        S             10i 0
     d rc              S             10i 0
     d brca            S              3
     d usid            S             10
     d prfx            S              2
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            MAIN   - Main Control Processing.                  *
      *                                                               *
      * CALLS      DOWNLD - Data Download Processing.                 *
      *            INCTRK - Incomplete Trickle Feed Processing.       *
      *            INIT   - Initial Processing.                       *
      *            RCVDTQ - Receive Dataqueue Processing.             *
      *            TRKLFD - Trickle Feed Processing.                  *
      *                                                               *
      *****************************************************************
      *
     C                   MOVEA     CPY@          MKI@             80
      *
     C                   EXSR      INIT
      *
      **  Loop while session is still active.
      *
     C     WACTIV        DOWEQ     'Y'
      *
     C                   SELECT
      *
      **  Data Download Request.
      *
     C     WDLRQ         WHENEQ    'Y'
     C                   EXSR      DOWNLD
      *
      **  Include Unprocessed Trickle Feed.
      *
     C     WITFRQ        WHENEQ    'Y'
     C                   EXSR      INCTRK
      *
      **  Trickle Feed Request.
      *
     C     WTFRQ         WHENEQ    'Y'
     C                   EXSR      TRKLFD
      *
     C                   OTHER
      *
      **  Check Branch Status.
      *
     C     WLOCK         IFEQ      'N'
     C                   EXSR      CHKBRS
     C                   ENDIF
      *
      **  Data Download requested.
      *
     C     A8BRST        IFEQ      'D'
      *
     C                   MOVEL     'Y'           WDLRQ
      *
     C                   ELSE
      *
      **  Receive Dataqueue Processing.
      *
     C                   EXSR      RCVDTQ
      *
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   SHTDN                                        60
     C     *IN60         IFEQ      *ON
     C                   MOVEL     'N'           WACTIV
     C                   ENDIF
      *
     C                   ENDDO
      *
     C***********          CALL 'QCMDEXC'              55                 118737
     C***********          PARM           WDLT                            118737
     C***********          PARM           LEN                             118737
      * Close Socket
     C                   eval      RetCode = Cls_Tcp( ScktNum )
      *
     C                   MOVE      '1'           *INLR
      *
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            CHKBRS - Check Branch Status.                      *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  MAIN   - Main Control Processing.                  *
      *            INIT   - Initial Processing.                       *
      *                                                               *
      *****************************************************************
     C     CHKBRS        BEGSR
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      PBRCA         @BRCA             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      **  Branch not found.
      *
     C     @RTCD         IFNE      *BLANKS
      *
      **  Report error.
      *
     C                   MOVEL     'USR0003'     @MSGID
     C                   MOVEL     PBRCA         WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
      *
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        RQHSMS
     C                   MOVE      'E'           RQHMSS
     C                   MOVE      @MSGID        RQHMSI
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4502'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      PBRCA         P#BRCA
     C                   PARM      'USR0003'     @MSGID
     C                   PARM                    @MSGDT
      *
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV
      *
      * Send STAT message
     C                   movel     '00000087'    header
     C                   move      'ERR'         header
     C                   clear                   Sbuffer
     C     Header        cat       FSTATR        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     PBRCA         DBKEY
     C                   Z-ADD     2             DBASE
     C                   EXSR      DBERR
      *
     C                   ELSE
      *
     C     A8BRST        IFEQ      'D'
     C                   MOVEL     'Y'           WDLRQ             1
     C                   ENDIF
      *                                                                   142083
     C**********         CALL      'AOBRCHR0'                                           14208 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD                                         14208
     C                   PARM      '*FREE  '     @OPTN                                         14208
     C                   PARM                    @BRCA                                         14208
     C**********         PARM                    DSFDY                                  14208 CGL029
     C                   PARM                    DSSDY                                        CGL029
      *
      **  Initialise Include Trickle Feed Required flag.
      *
     C                   MOVEL     'Y'           WITFRQ            1
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            RCVDTQ - Receive Dataqueue Processing.             *
      *                                                               *
      * CALLS      *PSSR  - Program Error.                            *
      *                                                               *
      * CALLED BY  MAIN   - Main Control Processing.                  *
      *                                                               *
      *****************************************************************
     C     RCVDTQ        BEGSR
      *
     C                   CALL      'QRCVDTAQ'    DTQRCV
      *
      **  If dataqueue is not empty.
      *
     C     LENR          IFGT      0
      *
      **  If dataqueue has Trickle Feed message
      *
     C     R#TFTP        IFEQ      'TF'
     C                   MOVE      R#BRCA        WTFBC
     C                   MOVE      R#ACNT        WTFAC
     C                   MOVE      R#TFTP        WTFTP
     C                   MOVE      R#TFSQ        WTFSQ
     C                   MOVE      'Y'           WTFRQ             1
     C                   ENDIF
      *
      **  If dataqueue has 'SUSP'end Branch Monitor message.
      *
     C     R#SUSP        IFEQ      'SUSP'
     C***********WLOCK     ANDEQ'N'                                       118516
     C                   EXSR      SNDSUS
      *
      **  Update the Branch Status.
      *
     C                   MOVE      'P'           W8BRST            1
     C     WLOCK         IFEQ      'N'                                                         11851
     C                   EXSR      UPDBRS
     C                   ENDIF                                                                 11851
     C                   ENDIF
      *
     C                   SELECT
     C     R#LOCK        WHENEQ    'COBLOCK'
     C                   MOVEL     'Y'           WLOCK
      *                                                                   118516
      ** Free the lock on the Branch Codes file for the COB Save.         118516
      *                                                                   118516
     C**********         CALL      'AOBRCHR0'                                           11851 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD                                         11851
     C                   PARM      '*FREE  '     @OPTN                                         11851
     C                   PARM                    @BRCA                                         11851
     C**********         PARM                    DSFDY                                  11851 CGL029
     C                   PARM                    DSSDY                                        CGL029
      *                                                                   118516
     C     R#LOCK        WHENEQ    'COBUNLCK'
     C                   MOVEL     'N'           WLOCK
     C                   ENDSL
      *
     C                   ELSE
      *
      **  Read the ICF File.
      *
     C                   EXSR      RCVSAC
      *
      **  Update the Branch Status if changed.
      *
     C     ACBRST        IFNE      WBRSSV
     C     ACBRST        ORNE      A8BRST                                                      17473
     C     WLOCK         ANDEQ     'N'
     C                   MOVEL     ACBRST        WBRSSV            1
     C                   MOVEL     ACBRST        W8BRST
     C                   EXSR      UPDBRS
     C                   ENDIF
      *
      **  Send Status message (for polling).
      *
     C     WACTIV        IFNE      'N'
      *
      **  Write the ICF File.
      *
      * Send STAT message
     C                   movel     '00000010'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       FSTATR        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            UPDBRS - Update Branch Status.                     *
      *                                                               *
      * CALLS      RCVSAC - Branch Status Acknowledgement on ICF Read.*
      *                                                               *
      * CALLED BY  RCVDTQ - Receive Dataqueue Processing.             *
      *                                                               *
      *****************************************************************
     C     UPDBRS        BEGSR
      *
     C                   OPEN      SDBRCHL0
      *
     C     PBRCA         CHAIN     SDBRCHL0                           41
      *
     C     *IN41         IFEQ      '1'
      *
     C                   MOVEL     'USR0003'     @MSGID
     C                   MOVEL     PBRCA         WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
      *
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        RQHSMS
     C                   MOVE      'E'           RQHMSS
     C                   MOVE      @MSGID        RQHMSI
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4502'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      PBRCA         P#BRCA
     C                   PARM      'USR0003'     @MSGID
     C                   PARM                    @MSGDT
      *
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV
      *
     C                   EXSR      RCVSAC
      *
      * Send STAT message
     C                   movel     '00000087'    header
     C                   move      'ERR'         header
     C                   clear                   Sbuffer
     C     Header        cat       FSTATR        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     PBRCA         DBKEY
     C                   Z-ADD     4             DBASE
     C                   EXSR      DBERR
      *
     C                   ELSE
      *
     C                   MOVEL     W8BRST        A8BRST
     C                   MOVEL     W8BRST        WBRSSV                                        17473
     C                   UPDATE    @A8REB1
      *
     C                   CLOSE     SDBRCHL0
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            RCVSAC - Branch Status Acknowledgement on ICF Read.*
      *                                                               *
      * CALLS      RCVDET - Detach instruction received on ICF Read.  *
      *                                                               *
      * CALLED BY  ACDWNL - Account Download Processing.              *
      *            DOWNLD - Data Download Processing.                 *
      *            INIT   - Initial Processing.                       *
      *            RCVDTQ - Receive Data Queue.                       *
      *            SCDWNL - Stopped Cheques Download Processing.      *
      *            SNDSUS - Send 'SUSP' msg to Host Monitor.          *
      *            TRKLFD - Trickle Feed Processing.                  *
      *                                                               *
      *****************************************************************
     C     RCVSAC        BEGSR
      *
     C                   MOVEL     *BLANKS       FSTATA
      *
      * Wait on socket
      *
     C**********         Eval      time_sec = 120
     C                   Eval      time_sec = 30
     C                   Eval      wait_act = *zeros
     C                   Eval      rc = *zeros
     C                   Eval      RetCode = Sel_tcp( ScktNum: time_sec:
     C                                      wait_act:rc)
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
      * Receive next message and map it to FSTATA format
      *
     C                   Eval      RetCode = Rcv_Tcp( ScktNum: Rbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   Else
     C                   eval      FSTATA= %subst(Rbuffer :12)
     C                   eval      MsgType= %subst(Rbuffer :9:3)
     C                   EndIf
      *
     C                   MOVEL     *BLANKS       WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
      *
     C     MsgType       IFEQ      'DET'
     C                   EXSR      RCVDET
     C                   ENDIF
      *
      **  If not Branch Status Acknowledgement, blanks, or abort.
      *
     C     FSTATA        IFEQ      *BLANKS
     C     ACABRT        OREQ      'Y'
      *
     C     FSTATA        IFEQ      *BLANKS
     C                   MOVEL     'USR0054'     @MSGID
     C                   MOVEL     'Blank msg'   WMDTA1
     C                   MOVEL     'TCP/IP  '    WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
      *
     C                   ELSE
      *
     C                   MOVEL     'USR0059'     @MSGID
     C                   MOVEL     PBRCA         WMDTA1
     C                   MOVEL     'TCP/IP  '    WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   ENDIF
      *
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        RQHSMS
     C                   MOVE      'E'           RQHMSS
     C                   MOVE      @MSGID        RQHMSI
      *
      **  Report error.
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4502'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      PBRCA         P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV
      *
      * Send STAT message
     C                   movel     '00000087'    header
     C                   move      'ERR'         header
     C                   clear                   Sbuffer
     C     Header        cat       FSTATR        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            TRKLFD - Trickle Feed Processing                   *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  MAIN   - Main Control Processing                   *
      *            INCTRK - Incomplete Trickle Feed Processing        *
      *                                                               *
      *****************************************************************
     C     TRKLFD        BEGSR
      *
     C                   OPEN      RECITFL1
      *
     C                   MOVE      'N'           WTFRQ
      *
     C                   MOVE      WTFBC         KTBRC
     C                   MOVE      WTFAC         KTACN
     C                   MOVE      WTFTP         KTYPE
     C                   MOVE      WTFSQ         KTSEQ
     C     KLTF          CHAIN     RECITFL1                           41
     C                   UNLOCK    RECITFL1
      *
      **  If the trickle feed record is found and status is incomplete.
      *
     C     *IN41         IFEQ      '0'
     C     RRTFST        ANDNE     'C'
      *
     C                   EXSR      RCVSAC
      *
     C     WACTIV        IFNE      'N'
      *
     C                   MOVEL     RRTFDT        WTFMT             4
      *
      **  Write the corresponding Trickle Feed msg to ICF file.
      *
     C                   SELECT
     C     WTFMT         WHENEQ    'TFAO'
     C                   MOVEL     RRTFDT        FLTFAO
      * Send TFAO message
     C                   movel     '00000149'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       FLTFAO        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
     C     WTFMT         WHENEQ    'TFAM'
     C                   MOVEL     RRTFDT        FLTFAM
      * Send TFAO message
     C**********         movel     '00000157'    header                                       213974
     C                   movel     '00000159'    header                                       213974
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       FLTFAM        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
     C     WTFMT         WHENEQ    'TFAD'
     C                   MOVEL     RRTFDT        FLTFAD
      * Send TFAD message
     C                   movel     '00000037'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       FLTFAD        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
     C     WTFMT         WHENEQ    'TFBL'
     C                   MOVEL     RRTFDT        FLTFBL
      * Send TFBL message
     C                   movel     '00000085'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       FLTFBL        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
     C     WTFMT         WHENEQ    'TFFC'
     C                   MOVEL     RRTFDT        FLTFFC
      * Send TFFC message
     C                   movel     '00000005'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       FLTFFC        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
     C     WTFMT         WHENEQ    'TFSU'
     C                   MOVEL     RRTFDT        FLTFSU
      * Send TFSU message
     C                   movel     '00000090'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       FLTFSU        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
     C     WTFMT         WHENEQ    'TFSD'
     C                   MOVEL     RRTFDT        FLTFSD
      * Send TFSD message
     C                   movel     '00000042'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       FLTFSD        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
     C                   ENDSL
      *
     C     KLTF          CHAIN     RECITFL1                           41
      *
      **  If the trickle feed record is found.
      *
     C     *IN41         IFEQ      '0'
     C                   MOVE      'C'           RRTFST
     C                   UPDATE    RECITFD1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   CLOSE     RECITFL1
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            DOWNLD - Data Download Processing.                 *
      *                                                               *
      * CALLS      ACDWNL - Account Download Processing               *
      *            SCDWNL - Stopped Cheques Download Processing       *
      *            DBERR  - Database Error Handling.                  *
      *            *PSSR  - Program Error.                            *
      *                                                               *
      * CALLED BY  MAIN   - Main Control Processing.                  *
      *                                                               *
      *****************************************************************
     C     DOWNLD        BEGSR
      *
     C                   MOVEL     'N'           WDLRQ
     C                   MOVEL     'N'           WACDL             1
     C                   MOVEL     'N'           WSCDL             1
     C                   MOVEL     'N'           WACLD             1
     C                   MOVEL     'N'           WSCLD             1
      *
     C                   OPEN      RECIADL0
     C                   OPEN      RECISCL0
      *
     C                   EXSR      RCVSAC
      *
      ****If*not*in*I/C*Initiation*or*Input*Cycle.*********************                       CCB020
      **  If not in Secondary COB or Input Cycle.                                             CCB020
      *
     C     WPHAS         IFNE      'A'
     C*****WPHAS         ANDNE     'F'                                                        CCB020
     C     WPHAS         ANDNE     'G'                                                        CCB020
      *
      **  Report error.
      *
     C                   MOVEL     'USR0014'     @MSGID
     C                   MOVEL     *BLANKS       WMDTA1           10
     C                   MOVEL     *BLANKS       WMDTA2           10
     C     WMDTA1        CAT       WMDTA2        @MSGDT
      *
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        RQHSMS
     C                   MOVE      'E'           RQHMSS
     C                   MOVE      @MSGID        RQHMSI
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4502'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      PBRCA         P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV
      *
      * Send STAT message
     C                   movel     '00000087'    header
     C                   move      'ERR'         header
     C                   clear                   Sbuffer
     C     Header        cat       FSTATR        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ELSE
      *
      **  Position LFs/RECSADL0 and RECSSCL0.
      *
     C                   MOVE      PBRCA         KBRCA
     C                   Z-ADD     1             KACNO
     C     KLACNT        SETLL     RECIADL0
     C     KLACNT        SETLL     RECISCL0
      *
     C                   READ      RECIADL0                               31
      *
      **  If Branch Code of record read is the same as the parameter,
      **  perform Account Details and Stopped Cheques Download.
      **  Perform initial read for Account Details Download.
      *
     C     *IN31         IFEQ      '0'
     C     RUBRCA        ANDEQ     PBRCA
     C     R#DLDB        IFEQ      'DBDL'                                       189857
     C                   MOVEL     'DWOL'        D#DWLD                         189857
     C                   ELSE                                                   189857
     C                   MOVEL     'DWLD'        D#DWLD
     C                   ENDIF                                                  189857
     C                   MOVE      WRDATE        D#DATE
      * Send DWLD message
     C                   movel     '00000010'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       FLDWLD        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
     C                   MOVEL     'Y'           WACDL
     C                   MOVEL     'Y'           WACLD
      *
      **  Perform initial read for Stopped Cheques Download.
      *
     C                   READ      RECISCL0                               32
     C     *IN32         IFEQ      '0'
     C     RTBRCA        ANDEQ     PBRCA
     C                   MOVEL     'Y'           WSCDL
     C                   MOVEL     'Y'           WSCLD
     C                   ENDIF
      *
      ** Perform the down loads if necessary
      *
     C     WACDL         IFEQ      'Y'
     C                   EXSR      ACDWNL
     C                   ENDIF
     C     WSCDL         IFEQ      'Y'
     C                   EXSR      SCDWNL
     C                   ENDIF
      *
     C                   EXSR      RCVSAC
      *
     C                   ELSE
      *
     C                   READ      RECISCL0                               32
      *
      **  Perform Stopped Cheques Download if the same branch.
      *
     C     *IN32         IFEQ      '0'
     C     RTBRCA        ANDEQ     PBRCA
     C**  If download for another branch                                        189857
     C     R#DLDB        IFEQ      'DBDL'                                       189857
     C                   MOVEL     'DWOL'        D#DWLD                         189857
     C                   ELSE                                                   189857
     C                   MOVEL     'DWLD'        D#DWLD
     C                   ENDIF                                                  189857
     C                   MOVE      WRDATE        D#DATE
      * Send DWLD message
     C                   movel     '00000010'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       FLDWLD        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
     C                   MOVEL     'Y'           WSCDL
     C                   MOVEL     'Y'           WSCLD
     C                   EXSR      SCDWNL
     C                   EXSR      RCVSAC
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Update Branch Status to 'S' if download was successful.
      *
     C     WACTIV        IFEQ      'Y'
     C     WACLD         ANDEQ     'Y'
     C     WLOCK         ANDEQ     'N'
     C     WACTIV        OREQ      'Y'
     C     WSCLD         ANDEQ     'Y'
     C     WLOCK         ANDEQ     'N'
      *
     C                   MOVE      'S'           W8BRST
     C                   EXSR      UPDBRS
      *
      **  Send Status message (for polling).
      *
      *
      * Send STAT message
     C                   movel     '00000010'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       FSTATR        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   CLOSE     RECIADL0
     C                   CLOSE     RECISCL0
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            ACDWNL - Account Download Processing.              *
      *                                                               *
      * CALLS      *PSSR  - Program Error                             *
      *                                                               *
      * CALLED BY  DOWNLD - Data Download Processing.                 *
      *                                                               *
      *****************************************************************
     C     ACDWNL        BEGSR
      *
     C     WACTIV        DOWEQ     'Y'
     C     WACDL         ANDEQ     'Y'
      *
     C                   EXSR      RCVSAC
      *
     C     WACTIV        IFNE      'N'
      *
     C                   MOVE      *BLANKS       FLDWAC
     C                   Z-ADD     0             DARCNT
     C                   MOVEL     'N'           DAMRDT
     C                   MOVE      RUBRCA        WCBRC             3
      *
     C     DARCNT        DOWLT     30
     C     RUBRCA        ANDEQ     WCBRC
     C     *IN31         ANDEQ     '0'
      *
     C                   ADD       1             DARCNT
      *
     C                   SELECT
     C     DARCNT        WHENEQ    1
     C                   MOVEL     DSACNT        DADB1
     C     DARCNT        WHENEQ    2
     C                   MOVEL     DSACNT        DADB2
     C     DARCNT        WHENEQ    3
     C                   MOVEL     DSACNT        DADB3
     C     DARCNT        WHENEQ    4
     C                   MOVEL     DSACNT        DADB4
     C     DARCNT        WHENEQ    5
     C                   MOVEL     DSACNT        DADB5
     C     DARCNT        WHENEQ    6
     C                   MOVEL     DSACNT        DADB6
     C     DARCNT        WHENEQ    7
     C                   MOVEL     DSACNT        DADB7
     C     DARCNT        WHENEQ    8
     C                   MOVEL     DSACNT        DADB8
     C     DARCNT        WHENEQ    9
     C                   MOVEL     DSACNT        DADB9
     C     DARCNT        WHENEQ    10
     C                   MOVEL     DSACNT        DADB10
     C     DARCNT        WHENEQ    11
     C                   MOVEL     DSACNT        DADB11
     C     DARCNT        WHENEQ    12
     C                   MOVEL     DSACNT        DADB12
     C     DARCNT        WHENEQ    13
     C                   MOVEL     DSACNT        DADB13
     C     DARCNT        WHENEQ    14
     C                   MOVEL     DSACNT        DADB14
     C     DARCNT        WHENEQ    15
     C                   MOVEL     DSACNT        DADB15
     C     DARCNT        WHENEQ    16
     C                   MOVEL     DSACNT        DADB16
     C     DARCNT        WHENEQ    17
     C                   MOVEL     DSACNT        DADB17
     C     DARCNT        WHENEQ    18
     C                   MOVEL     DSACNT        DADB18
     C     DARCNT        WHENEQ    19
     C                   MOVEL     DSACNT        DADB19
     C     DARCNT        WHENEQ    20
     C                   MOVEL     DSACNT        DADB20
     C     DARCNT        WHENEQ    21
     C                   MOVEL     DSACNT        DADB21
     C     DARCNT        WHENEQ    22
     C                   MOVEL     DSACNT        DADB22
     C     DARCNT        WHENEQ    23
     C                   MOVEL     DSACNT        DADB23
     C     DARCNT        WHENEQ    24
     C                   MOVEL     DSACNT        DADB24
     C     DARCNT        WHENEQ    25
     C                   MOVEL     DSACNT        DADB25
     C     DARCNT        WHENEQ    26
     C                   MOVEL     DSACNT        DADB26
     C     DARCNT        WHENEQ    27
     C                   MOVEL     DSACNT        DADB27
     C     DARCNT        WHENEQ    28
     C                   MOVEL     DSACNT        DADB28
     C     DARCNT        WHENEQ    29
     C                   MOVEL     DSACNT        DADB29
     C     DARCNT        WHENEQ    30
     C                   MOVEL     DSACNT        DADB30
     C                   ENDSL
      *
     C                   READ      RECIADL0                               31
      *
     C                   ENDDO
      *
     C     RUBRCA        IFNE      WCBRC
     C     *IN31         OREQ      '1'
     C                   MOVE      'N'           WACDL
     C                   ENDIF
      *
     C     DARCNT        IFEQ      30
     C     WACDL         ANDEQ     'Y'
     C     WSCDL         OREQ      'Y'
     C                   MOVEL     'Y'           DAMRDT
     C                   ENDIF
      *
     C                   MOVEL     'DWAC'        DATYPE
      * Send DWAC message
     C                   movel     '00006097'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       FLDWAC        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            SCDWNL - Stopped Cheques Download Processing       *
      *                                                               *
      * CALLS      *PSSR  - Program Error                             *
      *                                                               *
      * CALLED BY  DOWNLD - Data Download Processing.                 *
      *                                                               *
      *****************************************************************
     C     SCDWNL        BEGSR
      *
     C     WACTIV        DOWEQ     'Y'
     C     WSCDL         ANDEQ     'Y'
      *
     C                   EXSR      RCVSAC
      *
     C     WACTIV        IFNE      'N'
      *
     C                   MOVE      *BLANKS       FLDWSC
     C                   Z-ADD     0             DQRCNT
     C                   MOVEL     'N'           DQMRDT
     C                   MOVE      RTBRCA        WCBRC
      *
     C     DQRCNT        DOWLT     50
     C     RTBRCA        ANDEQ     WCBRC
     C     *IN32         ANDEQ     '0'
      *
     C                   ADD       1             DQRCNT
      *
     C                   SELECT
     C     DQRCNT        WHENEQ    1
     C                   MOVEL     DSSTCQ        DQDB1
     C     DQRCNT        WHENEQ    2
     C                   MOVEL     DSSTCQ        DQDB2
     C     DQRCNT        WHENEQ    3
     C                   MOVEL     DSSTCQ        DQDB3
     C     DQRCNT        WHENEQ    4
     C                   MOVEL     DSSTCQ        DQDB4
     C     DQRCNT        WHENEQ    5
     C                   MOVEL     DSSTCQ        DQDB5
     C     DQRCNT        WHENEQ    6
     C                   MOVEL     DSSTCQ        DQDB6
     C     DQRCNT        WHENEQ    7
     C                   MOVEL     DSSTCQ        DQDB7
     C     DQRCNT        WHENEQ    8
     C                   MOVEL     DSSTCQ        DQDB8
     C     DQRCNT        WHENEQ    9
     C                   MOVEL     DSSTCQ        DQDB9
     C     DQRCNT        WHENEQ    10
     C                   MOVEL     DSSTCQ        DQDB10
     C     DQRCNT        WHENEQ    11
     C                   MOVEL     DSSTCQ        DQDB11
     C     DQRCNT        WHENEQ    12
     C                   MOVEL     DSSTCQ        DQDB12
     C     DQRCNT        WHENEQ    13
     C                   MOVEL     DSSTCQ        DQDB13
     C     DQRCNT        WHENEQ    14
     C                   MOVEL     DSSTCQ        DQDB14
     C     DQRCNT        WHENEQ    15
     C                   MOVEL     DSSTCQ        DQDB15
     C     DQRCNT        WHENEQ    16
     C                   MOVEL     DSSTCQ        DQDB16
     C     DQRCNT        WHENEQ    17
     C                   MOVEL     DSSTCQ        DQDB17
     C     DQRCNT        WHENEQ    18
     C                   MOVEL     DSSTCQ        DQDB18
     C     DQRCNT        WHENEQ    19
     C                   MOVEL     DSSTCQ        DQDB19
     C     DQRCNT        WHENEQ    20
     C                   MOVEL     DSSTCQ        DQDB20
     C     DQRCNT        WHENEQ    21
     C                   MOVEL     DSSTCQ        DQDB21
     C     DQRCNT        WHENEQ    22
     C                   MOVEL     DSSTCQ        DQDB22
     C     DQRCNT        WHENEQ    23
     C                   MOVEL     DSSTCQ        DQDB23
     C     DQRCNT        WHENEQ    24
     C                   MOVEL     DSSTCQ        DQDB24
     C     DQRCNT        WHENEQ    25
     C                   MOVEL     DSSTCQ        DQDB25
     C     DQRCNT        WHENEQ    26
     C                   MOVEL     DSSTCQ        DQDB26
     C     DQRCNT        WHENEQ    27
     C                   MOVEL     DSSTCQ        DQDB27
     C     DQRCNT        WHENEQ    28
     C                   MOVEL     DSSTCQ        DQDB28
     C     DQRCNT        WHENEQ    29
     C                   MOVEL     DSSTCQ        DQDB29
     C     DQRCNT        WHENEQ    30
     C                   MOVEL     DSSTCQ        DQDB30
     C     DQRCNT        WHENEQ    31
     C                   MOVEL     DSSTCQ        DQDB31
     C     DQRCNT        WHENEQ    32
     C                   MOVEL     DSSTCQ        DQDB32
     C     DQRCNT        WHENEQ    33
     C                   MOVEL     DSSTCQ        DQDB33
     C     DQRCNT        WHENEQ    34
     C                   MOVEL     DSSTCQ        DQDB34
     C     DQRCNT        WHENEQ    35
     C                   MOVEL     DSSTCQ        DQDB35
     C     DQRCNT        WHENEQ    36
     C                   MOVEL     DSSTCQ        DQDB36
     C     DQRCNT        WHENEQ    37
     C                   MOVEL     DSSTCQ        DQDB37
     C     DQRCNT        WHENEQ    38
     C                   MOVEL     DSSTCQ        DQDB38
     C     DQRCNT        WHENEQ    39
     C                   MOVEL     DSSTCQ        DQDB39
     C     DQRCNT        WHENEQ    40
     C                   MOVEL     DSSTCQ        DQDB40
     C     DQRCNT        WHENEQ    41
     C                   MOVEL     DSSTCQ        DQDB41
     C     DQRCNT        WHENEQ    42
     C                   MOVEL     DSSTCQ        DQDB42
     C     DQRCNT        WHENEQ    43
     C                   MOVEL     DSSTCQ        DQDB43
     C     DQRCNT        WHENEQ    44
     C                   MOVEL     DSSTCQ        DQDB44
     C     DQRCNT        WHENEQ    45
     C                   MOVEL     DSSTCQ        DQDB45
     C     DQRCNT        WHENEQ    46
     C                   MOVEL     DSSTCQ        DQDB46
     C     DQRCNT        WHENEQ    47
     C                   MOVEL     DSSTCQ        DQDB47
     C     DQRCNT        WHENEQ    48
     C                   MOVEL     DSSTCQ        DQDB48
     C     DQRCNT        WHENEQ    49
     C                   MOVEL     DSSTCQ        DQDB49
     C     DQRCNT        WHENEQ    50
     C                   MOVEL     DSSTCQ        DQDB50
     C                   ENDSL
      *
     C                   READ      RECISCL0                               32
      *
     C                   ENDDO
      *
     C     RTBRCA        IFNE      WCBRC
     C     *IN32         OREQ      '1'
     C                   MOVE      'N'           WSCDL
     C                   ENDIF
      *
     C     DQRCNT        IFEQ      50
     C     WSCDL         ANDEQ     'Y'
     C                   MOVEL     'Y'           DQMRDT
     C                   ENDIF
      *
     C                   MOVEL     'DWSC'        DQTYPE
      * Send DWSC message
     C                   movel     '00004307'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       FLDWSC        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            INCTRK - Incomplete Trickle Feed Processing        *
      *                                                               *
      * CALLS      TRKLFD - Trickle Feed Processing                   *
      *                                                               *
      * CALLED BY  MAIN   - Main Control Processing                   *
      *                                                               *
      *****************************************************************
     C     INCTRK        BEGSR
      *
     C                   OPEN      RECITFL0
      *
     C     PBRCA         CHAIN     RECITFL0                           33
      *
     C     WACTIV        DOWEQ     'Y'
     C     *IN33         ANDEQ     '0'
      *
     C     RRTFST        IFEQ      *BLANK
     C                   MOVE      RRBRCA        WTFBC             3
     C                   MOVE      RRACNT        WTFAC            10
     C                   MOVE      RRTFTP        WTFTP             2
     C                   MOVE      RRTFSQ        WTFSQ             6
     C                   EXSR      TRKLFD
     C                   ENDIF
      *
     C                   READE     RECITFL0                               33
     C                   ENDDO
      *
      **  Reset Include Trickle Feed Required flag.
      *
     C                   MOVEL     'N'           WITFRQ
      *
     C                   CLOSE     RECITFL0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
      *                                                               *
      *            RTVMSG - Retrieve Message from Message File        *
      *                                                               *
      * CALLS     REC4160 - Retrive Message from Message File         *
      *                                                               *
      * CALLED BY  MOVDET - Move Details to Send to Outgoing DataQ    *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
      *
     C     RTVMSG        BEGSR
      *
     C                   CALL      'REC4160'
     C                   PARM                    @MSGID            7
     C                   PARM                    @MSGF            10
     C                   PARM                    @MSGDT          256
     C                   PARM      *BLANKS       @MSGTX           80
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            INIT   - Initial Processing.                       *
      *                                                               *
      * CALLS      ZDATE2 - Convert Midas dayno to a date format      *
      *            DBERR  - Database Error Handling                   *
      *            *PSSR  - Program Error.                            *
      *                                                               *
      * CALLED BY  MAIN   - Main Control Processing.                  *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      **  Define Entry list
      *
     C     *entry        plist
     C                   parm                    ScktNum
     C                   parm                    brca
     C                   parm                    usid
     C                   parm                    prfx
      *
      **  Clear DB ERROR information in LDA.
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     *BLANK        DBLOT
     C                   OUT       LDA
      *
     C     *DTAARA       DEFINE                  MPHAS
     C                   IN        MPHAS
      *
      **  Define keylist.
      *
     C     KLACNT        KLIST
     C                   KFLD                    KBRCA             3
     C                   KFLD                    KACNO            10 0
      *
     C     KLTF          KLIST
     C                   KFLD                    KTBRC             3
     C                   KFLD                    KTACN            10
     C                   KFLD                    KTYPE             2
     C                   KFLD                    KTSEQ             6
      *
      **  Define Parmlist(s).
      **  Parameters for QRCVDTAQ (From RBA).
      *
     C     DTQRCV        PLIST
     C                   PARM                    DTAQR
     C                   PARM                    LIBR
     C                   PARM                    LENR
     C                   PARM                    DATR
     C                   PARM                    WAITR
      *
      ** Check if SAR CRT301 is set on.
      ** It is 'ON' if there is a local database on the PC.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CRT301'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CRT301            1
     C                   ELSE
     C                   MOVE      'N'           CRT301
     C                   END
      *                                                                   118737
      **  Allocate lock on branch data area.                              118737
      *                                                                   118737
     C                   MOVEL     ALC(1)        @CMD                                          11873
     C                   MOVE      PBRCA         @BRC                                          11873
      *                                                                   118737
     C                   CALL      'QCMDEXC'                                                   11873
     C                   PARM                    @CMD                                          11873
     C                   PARM      80            LEN              15 5                         11873
      *
      **  Set the value of the Branch Trickle Feed data queue name.
      *
     C     'CASHTF_'     CAT       PBRCA         WTFBR            10
      *
      **  Set up parameters for the Branch Trickle Feed data queue.
      *
     C                   MOVEL     WTFBR         DTAQR            10
     C                   MOVEL     '*LIBL'       LIBR             10
     C                   Z-ADD     29            LENR              5 0
     C                   Z-ADD     60            WAITR             5 0
      *
      ****Set*the*value*of*the*Branch*Monitor*Data*Area**                 118737
      ****and*build*the*command*DLTDTAARA*{Branch*Monitor*DTAARA}.**      118737
      ***********                                                         118737
     C***********'CASH_'   CAT  PBRCA     WBMDA  10                       118737
      ***********                                                         118737
     C***********          MOVEL'DLT'     WLT3    3                       118737
     C***********          MOVEL'DTAARA ' WLT7    7                       118737
     C***********WLT3      CAT  WLT7      WLT10  10                       118737
      ***********                                                         118737
     C***********WLT10     CAT  WBMDA     WDLT   20                       118737
     C***********          Z-ADD20        LEN    155                      118737
      *
     C                   CALL      'SF0410'
     C                   PARM      *BLANKS       PGRP             50
     C                   PARM      USRID         PUSR             25
     C                   PARM      *ZEROS        PLVL              4 0
     C                   PARM      *ZEROS        PTIM              5 0
     C                   PARM      *ZEROS        PERR              1 0
     C                   PARM      *BLANKS       PMLT              2
      *
     C     PMLT          IFEQ      *BLANK
     C                   MOVEL     'GB'          PMLT
     C                   ENDIF
      *
     C     PMLT          CAT       'CIMSGF'      @MSGF            10
     C                   MOVEL     *BLANKS       PMSID             7
      *
      **  Set Session Active Flag.
      *
     C                   MOVEL     'Y'           WACTIV            1
     C                   MOVEL     'N'           WLOCK             1
      *
     C                   MOVEL     'STAT'        RQSTAT
     C                   MOVEL     *BLANKS       RQHMSS
     C                   MOVEL     *BLANKS       RQHMSI
     C                   MOVEL     *BLANKS       RQHSMS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  If error on access to Bank Details.
      *
     C     @RTCD         IFNE      *BLANKS
      *
      **  Report error.
      *
     C                   MOVEL     'USR0051'     @MSGID
     C                   MOVEL     *BLANKS       WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
      *
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        RQHSMS
     C                   MOVE      'E'           RQHMSS
     C                   MOVE      @MSGID        RQHMSI
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4502'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      PBRCA         P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV
      *
      ** Send ERR message
      *
     C                   movel     '00000087'    header
     C                   move      'ERR'         header
     C                   clear                   Sbuffer
     C     Header        cat       FSTATR        Sbuffer
      * Send ERR message
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
      **  Set up LDA DBERR.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     1             DBASE
     C                   EXSR      DBERR
      *
     C                   ELSE
      *
      **  System run date.
      *
     C                   Z-ADD     BJRDNB        ZDAYNO
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      '0'           *IN98
     C                   ELSE
     C                   MOVE      '1'           *IN98
     C                   ENDIF
      *
     C                   Call      'ZDATE2'
     C                   Parm                    ZDAYNO            5 0
     C                   Parm                    ZDATFM            1
     C                   Parm                    ZDATE             6 0
     C                   Parm                    ZADATE            7
     C                   Z-ADD     ZDATE         WRDATE            6 0
      *
      * Send BOK message (Reply to BOK received in listener)
     C                   movel     '00000000'    header
     C                   move      'BOK'         header
     C                   clear                   Sbuffer
     C                   movel     header        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
      * Wait on socket
      *
     C                   Eval      time_sec = 30
     C                   Eval      wait_act = *zeros
     C                   Eval      rc = *zeros
     C                   Eval      RetCode = Sel_tcp( ScktNum: time_sec:
     C                                      wait_act:rc)
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C     CRT301        IFEQ      'Y'
     C     WLOCK         ANDEQ     'N'
     C                   EXSR      CHKBRS
     C                   ENDIF
      *
     C     WACTIV        IFNE      'N'
      *
      ** Send STAT message
      *
     C                   movel     '00000010'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       FSTATR        Sbuffer
      * Send ERR message
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            RCVDET - Detach instruction received on ICF Read.  *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  INIT   - Initial Processing.                       *
      *            RCVSAC - Branch Status Acknowledgement on ICF Read.*
      *                                                               *
      *****************************************************************
     C     RCVDET        BEGSR
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0067'     @MSGID
     C                   MOVEL     PBRCA         WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
      *
      **  Report error.
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4502'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      PBRCA         P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C***********          CALL 'QCMDEXC'              55                 118737
     C***********          PARM           WDLT                            118737
     C***********          PARM           LEN                             118737
      *
      * Close Socket and exit
      *
     C                   eval      RetCode = Cls_Tcp( ScktNum )
      *
      **  End the program.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            SNDSUS - Send 'SUSP' msg to Host Monitor.          *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  RCVDTQ - Receive Dataqueue Processing.             *
      *                                                               *
      *****************************************************************
     C     SNDSUS        BEGSR
      *
      **  Receive outstanding messages.
      *
     C                   EXSR      RCVSAC
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0065'     @MSGID
     C                   MOVEL     PBRCA         WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
      *
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        RQHSMS
     C                   MOVE      'C'           RQHMSS
     C                   MOVE      @MSGID        RQHMSI
      *
      **  Report error.
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4502'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      PBRCA         P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
      **  Write 'SUSP' msg to the host monitor
      *
     C                   MOVEL     'SUSP'        RQSTAT
      *
      * Send STAT message
     C                   movel     '00000010'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       FSTATR        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
      *                                                               *
      *            TCPERR - Report Communication error                *
      *                                                               *
      * CALLS     REC4411 - Midas RE CI Comms Program Error Report    *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     TCPERR        BEGSR
      *
     C                   MOVEL     'USR0090'     @MSGID
     C                   MOVEL     *BLANKS       WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4502'      PROG             10
     C                   PARM                    JOBNUM            6
     C                   PARM      '0000'        MMCODE            4
     C                   PARM      PBRCA         P#BRCA            3
     C                   PARM                    @MSGID            7
     C                   PARM                    @MSGDT
      * Close Socket
     C                   Eval      RetCode = Cls_Tcp( ScktNum )
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'TCP COMM'    DBFILE
     C                   MOVEL     *BLANKS       DBKEY
     C                   Z-ADD     99            DBASE
      *
     C                   EXSR      DBERR
     C                   EXSR      *PSSR
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            DBERR  - Database Error Handling.                  *
      *                                                               *
      * CALLS      *PSSR  - Program Error.                            *
      *                                                               *
      * CALLED BY  INIT   - Initial Processing.                       *
      *                                                               *
      *****************************************************************
     C     DBERR         BEGSR
      *
     C                   MOVEL     PROG          DBPGM
     C                   OUT       LDA
      *
     C                   DUMP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            *PSSR  - Program Error.                            *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY         -                                           *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ****Delete*the*Branch*Data*Area.**                                  118737
      ***********                                                         118737
     C***********          CALL 'QCMDEXC'              55                 118737
     C***********          PARM           WDLT                            118737
     C***********          PARM           LEN                             118737
      *
     C                   DUMP
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**   ALC  - Command for ALCOBJ in QCMDEXEC                                118737
ALCOBJ  OBJ((CASH_     *DTAARA *EXCL))
