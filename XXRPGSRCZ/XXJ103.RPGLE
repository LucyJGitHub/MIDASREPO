     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Pooling Account Status')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      ***SDJ103*-*MIDAS*SD*Pooling*Account Status**********************         JMI108
      *  XXJ103 - MIDAS SD Pooling Account Status                     *         JMI108
      *                                                               *
      *  Function:  This program allows users to enquire FTP          *
      *             incoming/outgoing status.                         *
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************         JMI108
      *  (c) Finastra International Limited 2018                      *         JMI108
      *                                                               *
      *  Last Amend No. JMI108             Date 31May18               *
      *  Prev Amend No. TFJ11A             Date 01Feb07               *
      *                 TFJ011  (CHG141)   Date 31Aug05               *
      *                 TFJ011  (CHG014)   Date 26Aug05               *
      *                 TFJ011  (CHG007)   Date 12Aug05               *
      *                 TFJ011  (CHG006)   Date 07Jul05               *
      *                 TFJ011  (CHG005)   Date 05Jul05               *
      *                 TFJ011  (CHG004)   Date 05Jul05               *
      *                 TFJ011  (CHG003)   Date 01Jul05               *
      *                 TFJ011  (CHG002)   Date 24Jun05               *
      *                 TFJ011  (CHG001)   Date 16Jun05               *
      *                 TFJ011  *CREATE    Date 05Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI108 - Account Balance Pooling. Upgrade to FBM 2.1         *
      *  TFJ11A - Account Transfer Service                            *
      *  TFJ011 - (CHG141) Further Requirements by client             *
      *  TFJ011 - (CHG014) Create a Data Error Report                 *
      *  TFJ011 - (CHG007) Changes due to Difference of the File      *
      *           System                                              *
      *  TFJ011 - (CHG006) Call GLCJ106 to allocate files before      *
      *           call to GLJ106                                      *
      *  TFJ011 - (CHG005) Upon retry, the Received records are       *
      *           deleted in the Status file instead of the Sent      *
      *  TFJ011 - (CHG004) Upon retry, change the owner of FTPd files *
      *           as per the system's owner to handle authority prob  *
      *  TFJ011 - (CHG003) Retry FTP Script Set Error.  The fields    *
      *           are not cleared, thus when retry is done, fields    *
      *           are set incorrectly.                                *
      *  TFJ011 - (CHG002) Upon retry, program fails since previously *
      *           opened files are being opened again                 *
      *  TFJ011 - (CHG001) Upon retry, delete original details        *
      *  TFJ011 - Account Pooling                                     *
      *                                                               *
      *****************************************************************
     F***SDJ103DF  CF   E             WORKSTN USROPN                            JMI108
     FXXJ103DF  CF   E             WORKSTN USROPN                               JMI108
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      ** DSP: Midas Account Pooling Status Enquiry
      *
     F***SDPSTSV0  IF   E           K DISK    INFSR(*PSSR)
     FXXPSTSV0  IF   E           K DISK    INFSR(*PSSR)                         JMI108
     F                                     INFDS(INFDS1)                        JMI108
     F                                     PREFIX(V0_)
     F                                     USROPN
      ** RTV : Midas SD Pooling ICD Details
      *
     F***GLPMINPP  O  A E           K DISK    INFSR(*PSSR)
     FXXPMINPP  O  A E           K DISK    INFSR(*PSSR)                         JMI108
     F                                     INFDS(ID0002)                        JMI108
      **  Midas SD Account Pooling FTP Manual Input File
      *
     F***SDPSTSV1  UF   E           K DISK    INFSR(*PSSR)
     FXXPSTSV1  UF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(ID0003)
     F************************************ RENAME(SDPSTSD0:SDPSTSD1)            JMI108
     F                                     RENAME(XXPSTSD0:XXPSTSD1)            JMI!08
     F                                     USROPN
      **  Midas SD Pooling ICD Details
      *                                                                                       CHG001
     FGLJEIPL1  UF   E           K DISK    INFSR(*PSSR)                                       CHG001
     F                                     USROPN                                             CHG001
      **  Midas GL Interface Batch Details file                                               CHG001
      *                                                                                       CHG001
     FGLJEIHL1  UF   E           K DISK    INFSR(*PSSR)                                       CHG001
     F                                     USROPN                                             CHG001
      **  Midas GL Interface Batch Header file                                                CHG001
      *                                                                                       CHG001
     F***GLPLDTV0  UF   E           K DISK    INFSR(*PSSR)                             CHG001 JMI108
     FXXPLDTV0  UF   E           K DISK    INFSR(*PSSR)                                       JMI108
     F                                     PREFIX(V1_)                                        CHG001
     F                                     USROPN                                             CHG001
      **  Midas GL Pooling Details file                                                       CHG001
      ********************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *
      /EJECT
      *
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
      *
     D**** SDPFTPDA      E DS                  EXTNAME(SDPFTPDA)                JMI108
     D XXPFTPDA      E DS                  EXTNAME(XXPFTPDA)                    JMI108
      *
     D*** DSPSTSV1      E DS                  EXTNAME(SDPSTSV1)                 JMI108
     D DSPSTSV1      E DS                  EXTNAME(XXPSTSV1)                    JMI108
      ** Data Area giving Installation Control Details
      *
      ** Data structures:
      *
      ***Data*structure*for*User ID on PF/GLPMINPD                              JMI108
      ** Data structure for User ID on PF/XXPMINPD                              JMI108
     D@USRID           DS
     D USER                    1     20
     D PASW                   22     41

      ***Data*Structure*for*GET write to PF/GLPMINPD                            JMI108
      ** Data Structure for GET write to PF/XXPMINPD                            JMI108
     D@GET             DS
     D GET                     1      3
     D @1                      4      4
     D PATH                    5     35
     D @3                     36     36
     D LIBNM                  37     46
     D @4                     47     47
     D FILNM                  48     57
     D @5                     58     58
     D REPLC                  59     71
      *
      ***Data*Structure*for*PUT write to PF/GLPMINPD                            JMI108
      ** Data Structure for PUT write to PF/XXPMINPD                            JMI108
     D@PUT             DS
     D PUT                     1      3
     D @6                      4      4
     D LIBNMO                  5     14
     D @7                     15     15
     D FILNMO                 16     25
     D @8                     26     26
     D PATHO                  27     57
      *
     D RUNDAT          DS
     D   MRDT                  1      7
     D   RDNB                  8     10P 0
     D   SUC                  11     11
     D   DFF                  12     12
     D   MBIN                 13     13
      *
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** File information data structure
      *
     D ID0001          DS           528
      ** File information data structure
      *
     D ID0002          DS           528
      ** File information data structure
      *
     D ID0003          DS           528
      ** File information data structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Midas SD Bank Details
      *
     D*** SDPICD        E DS                  EXTNAME(SDPICDPP)                 JMI108
     D XXPICD        E DS                  EXTNAME(XXPICDPP)                    JMI108

     D ICD_JIBRCH    E                     EXTFLD(JIBRCH)                                     CHG001
      ** Midas SD Pooling ICD Details
      *
     D A@CPY           DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
      /EJECT
      ** Data structures:
      *
     D WTime           DS
     D  WHour                  1      2
     D  WColon                 3      3
     D  WMin                   4      5
      *
     D ZFieldN         DS
     D  HH#PITM                1      2S 0
     D  MM#PITM                3      4S 0
      *
     D WIFJE           DS
     D  WIBtch                 1      3
     D  WDash                  4      4
     D  WBtch                  5      7
      *
     D DSRetryI        DS
     D  RISEQA                 1      1    INZ(' ')
     D  RISEQB                 2      2    INZ(' ')
     D  RISEQC                 3      3    INZ(' ')
     D  RISEQ1                 4      4
     D  RISEQ2                 5      5
     D  RISEQ3                 6      6
     D  RISEQ4                 7      7
     D  RISEQ5                 8      8
     D  RISEQ6                 9      9
     D  RISEQ7                10     10
     D  RISEQ8                11     11
     D  RISEQ9                12     12
     D  RISEQ10               13     13
     D  RISEQ11               14     14
     D  RISEQ12               15     15
     D  RISEQ13               16     16
     D  RISEQ14               17     17
     D  RISEQ15               18     18
     D  RISEQ16               19     19
     D  RISEQ17               20     20
     D  RISEQ18               21     21
     D  RISEQ19               22     22
     D  RISEQ20               23     23
      *
     D DSRetryO        DS
     D  ROFIDR                 1      1
     D  RORECR                 2      2
     D  ROCOBR                 3      3
     D  ROSEQ1                 4      4
     D  ROSEQ2                 5      5
     D  ROSEQ3                 6      6
     D  ROSEQ4                 7      7
     D  ROSEQ5                 8      8
     D  ROSEQ6                 9      9
     D  ROSEQ7                10     10
     D  ROSEQ8                11     11
     D  ROSEQ9                12     12
     D  ROSEQ10               13     13
     D  ROSEQ11               14     14
     D  ROSEQ12               15     15
     D  ROSEQ13               16     16
     D  ROSEQ14               17     17
     D  ROSEQ15               18     18
     D  ROSEQ16               19     19
     D  ROSEQ17               20     20
     D  ROSEQ18               21     21
     D  ROSEQ19               22     22
     D  ROSEQ20               23     23
      /EJECT
      *
      ** Data Structures used by Access Programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      /EJECT
      *
      ** Parameter declarations
     D P2PARM          DS
      ** O :  *Return code
     D  P2RTN                  1      7
     D P3PARM          DS
      ** B : MAP Work Return code
     D  P3WRTC                 1      5
     D                 DS
     D  ZAPGMQ         S             10
     D  ZAPGRL         S              5
     D  ZAMSID         S              7
     D  ZAMSGF         S             10
     D  ZAMSDA         S            132
     D  ZAMSTP         S              7
     D  TITLE          S              7
     D  PRtCd          S              7
     D  POptn          S              7
     D  WDigit         S              2  0
     D  ERR            S              1
     D  KSeq           S              3
     D  KRcv           S              1    INZ('R')
     D  KSnt           S              1    INZ('S')
     D  ARRRetry       S              1    DIM(23)
     D  V@FTP          S              4
     D  KType          S              1
     D  P@InsTyp       S              3
     D  V@Desc         S              3
     D  RetryOK        S              1    INZ('N')
     D  PLevl          S              1
     D  PEnty          S              3
     D  PAPSeq         S              3
     D  PFilNm         S             10
     D  PSeq           S              3
     D  PTransm        S              7
      *
      ** Parameters for QCMDEXC
     D  PCommand1      S              1    DIM(27) CTDATA PERRCD(27)
     D  PCommand2      S              1    DIM(27) CTDATA PERRCD(27)
     D  PCommand3      S              1    DIM(73) CTDATA PERRCD(73)                          CHG004
     D  PCommand4      S              1    DIM(34) CTDATA PERRCD(34)                          CHG006
     D  PCommand5      S              1    DIM(34) CTDATA PERRCD(34)                          TFJ11A
     D  PCommandLen    S             15P 5 INZ(27)
     D  PCommandLen2   S             15P 5 INZ(73)                                            CHG004
     D  PCommandLen3   S             15P 5 INZ(34)                                            CHG006
      *
     D File_Name       S              1    DIM(10)
     D PATHA           S              1    DIM(31)
     D  WProtInd       S              1  0 DIM(20)
     D  InProtInd      S              1  0 DIM(20)
     D  OutProtInd     S              1  0 DIM(20)
      *
     D  REPLACE        C                   '(*REPLACE)'
     D  Wopen          S              1    INZ('N')
     D  WUMBIN         S              1    INZ(' ')
      /EJECT
      *****************************************************************
      *
      ** Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P2RTN         PARM      P2RTN         WP0001            7
     C     P3WRTC        PARM      P3WRTC        WP0002            5
      *****************************************************************
      ** Initialize
     C                   EXSR      ZZINIT
      *
      ** Perform once if all passed, else repeat
      ** Display and process key screen
     C
     C                   EXSR      BADSKY
     C
      ** Terminate program
     C                   EXSR      ZXEXPG
      *
      /EJECT
      *****************************************************************
     C     BADSKY        BEGSR
      *
      ** Display and process key screen
      *
     C     *IN30         DOUEQ     '1'
      *
      ** If error write messages
     C                   IF        ERR = 'Y'
     C                   WRITE     #MSGCTL
     C                   ENDIF
      *
     C                   WRITE     #RCDKEY
     C                   WRITE     #CMDTXT1
      * FTP Incoming
     C***87              EXFMT     SDJ103DI                                     JMI108
     C   87              EXFMT     XXJ103DI                                     JMI108
      * FTP Outgoing
     C**N87              EXFMT     SDJ103DO                                     JMI108
     C  N87              EXFMT     XXJ103DO                                     JMI108
     C                   EXSR      CLEAR
      *
      ** Process response to screen
      ** Cancel & exit program
     C   03              CAS                     ZXEXPG
     C   05              CAS                     RESET
     C   14              CAS                     SROutG
     C   15              CAS                     SRInCo
      ** Process key screen input
     C                   CAS                     VALID
     C                   ENDCS
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * Clear message file
      *****************************************************************
     C     CLEAR         BEGSR
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     C     RESET         BEGSR
      *
      ** Clear the program message queue and call SR/INIT to retrieve
      ** the last committed data from the extension file.
      *
     C                   EXSR      SRUnProt
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL
     C                   EXSR      ZZINIT
      *
      ** Reset all error indicators
      *
     C                   MOVE      MBIN          WUMBIN            1
     C                   IF        PERR <> 1
     C                   EXSR      CLRIND
     C                   SETOFF                                       81
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     C     SROutG        BEGSR
      *
      ** FTP Outgoing mode
      *
     C                   IF        *IN87 = *ON
     C                   EXSR      SRUnProt
     C                   EXSR      SRProtSwtch
      *
      ** Reset all error indicators
      *
     C                   EXSR      CLRIND
     C                   SETOFF                                       87
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL
     C                   EXSR      ZZINIT
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     C     SRInco        BEGSR
      *
      ** FTP Incoming mode
      *
     C                   IF        *IN87 = *OFF
     C                   EXSR      SRUnProt
     C                   EXSR      SRProtSwtch
      *
      ** Reset all error indicators
      *
     C                   EXSR      CLRIND
     C                   SETON                                        87
     C                   EXSR      CLEAR
     C                   WRITE     #MSGCTL
     C                   EXSR      ZZINIT
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     C     SRFTPGo       BEGSR
      ** Clear FTP details files
     C****************** CLOSE     GLPMINPP                                     JMI108
     C                   CLOSE     XXPMINPP                                     JMI108
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCommand1
     C                   PARM                    PCommandLen
      *
     C                   CALL      'QCMDEXC'
     C                   PARM                    PCommand2
     C                   PARM                    PCommandLen
      *
      ** FTP Incoming Mode
     C                   IF        *IN87 = *ON
      *
      * Set up FTP details
     C                   EXSR      Set_FTPIn
      *
     C****************** CALL      'GLCJ104'                                    JMI108
     C                   CALL      'XXCJ114'                                    JMI108
     C                   PARM      *BLANKS       @RtCd             7
     C                   PARM      'MANUALR'     PTransm
     C                   PARM      NAlpha        PSeq
     C                   PARM      FILNM         PFilNm
      *
     C                   IF        @RtCd = *BLANKS
      *                                                                                       CHG004
      ** Change Object owner                                                                  CHG004
      *                                                                                       CHG004
     C                   MOVEA     PFilNm        PCommand3(15)                                CHG004
     C                   MOVEA     LIBR          PCommand3(49)                                CHG004
     C                   CALL      'QCMDEXC'                                                  CHG004
     C                   PARM                    PCommand3                                    CHG004
     C                   PARM                    PCommandLen2                                 CHG004
      *                                                                                       CHG014
      ** Generate Data Error Report before calling GLJ106                                     CHG014
      *                                                                                       CHG014
     C****************** CALL      'GLCJ113'                                           CHG014 JMI108
     C                   CALL      'XXCJ123'                                                  JMI108
     C                   PARM      *BLANKS       @RtCd             7                          CHG014
     C                   PARM      *blanks       @PSeq             5                          CHG014
     C                   PARM      *blanks       @PLevl            1                          CHG014
     C                   PARM      *blanks       @PEnty            3                          CHG014
     C                   PARM      NAlpha        PSeq                                         CHG141
      *                                                                                       CHG014
     C                   IF        @RtCd <> *Blanks                                           CHG014
     C     *LOCK         IN        LDA                                                        CHG014
     C****************** MOVEL     'GLPIDLPP'    DBFILE                                CHG014 JMI108
     C                   MOVEL     'XXPIDLPP'    DBFILE                                       JMI108
     C                   MOVEL     '902'         DBASE                                        CHG014
     C                   MOVEL     'CALL'        DBKEY                                        CHG014
     C                   OUT       LDA                                                        CHG014
     C                   EXSR      *PSSR                                                      CHG014
     C                   END                                                                  CHG014
      *
      ***Output*to*Status*file*SDPSTSV1*****                                    JMI108
      ** Output to Status file XXPSTSV1                                         JMI108
      *
     C                   EXSR      SRSavSts
      *
     C****************** CLOSE     SDPSTSV0                                     JMI108
     C                   CLOSE     XXPSTSV0                                     JMI108
     C****************** CALL      'GLJ106'                                     JMI108
     C                   CALL      'XXJ116'                                     JMI108
     C                   PARM      *BLANKS       @RtCd             7
     C                   PARM      *BLANKS       PPrcType          1
     C                   PARM      NAlpha        PSeq
      *
     C****************** OPEN      SDPSTSV0                                     JMI108
     C                   OPEN      XXPSTSV0                                     JMI108
     C                   IF        @RtCd = *BLANKS
     C                   SELECT
      *
      ** Produce Journal Entries Pooling Instructions
     C                   WHEN      PPrcType = 'P'
      *
     C****************** CALL      'GLCJ110'                                    JMI108
     C                   CALL      'XXCJ120'                                    JMI108
     C                   PARM      NAlpha        @PAPSeq           3
     C                   PARM      *blanks       @PSeq             5
     C                   PARM      *blanks       @PLevl            1
     C                   PARM      *blanks       @PEnty            3
      *
      ** Produce Money Market Pooling Instructions
     C                   WHEN      PPrcType = 'S'
      *
     C****************** CALL      'GLCJ111'                                    JMI108
     C                   CALL      'XXCJ121'                                    JMI!08
     C                   PARM      NAlpha        @PAPSeq           3
     C                   PARM      *blanks       @PSeq             5
     C                   PARM      *blanks       @PLevl            1
     C                   PARM      *blanks       @PEnty            3
      *
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** FTP Outgoing Mode
     C                   IF        *IN87 = *OFF
      *
      * Set up FTP details
     C                   EXSR      Set_FTPOut
      *
     C****************** CALL      'GLCJ104'                                    JMI108
     C                   CALL      'XXCJ114'                                    JMI108
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      'MANUALS'     PTransm
     C                   PARM      NAlpha        PSeq
     C                   PARM      FILNMO        PFilNm
      *
     C                   IF        PRtCd = *BLANKS
      *                                                                                       CHG004
      ** Change Object owner                                                                  CHG004
      *                                                                                       CHG004
     C                   MOVEA     PFilNm        PCommand3(15)                                CHG004
     C                   MOVEA     LIBR          PCommand3(49)                                CHG004
     C                   CALL      'QCMDEXC'                                                  CHG004
     C                   PARM                    PCommand3                                    CHG004
     C                   PARM                    PCommandLen2                                 CHG004
      *
      ***Output*to*Status*file SDPSTSV1                                         JMI108
      ** Output to Status file XXPSTSV1                                         JMI108
      *
     C                   EXSR      SRSavSts
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT                                                                                  CHG001
      *****************************************************************                       CHG001
     C     SRDeleteDt    BEGSR                                                                CHG001
      *                                                                                       CHG001
      ** Delete Details of existing file sequence                                             CHG001
     C                   MOVE      NAlpha        KSeq                                         CHG001
     C                   IF        *IN87 = *ON                                                CHG005
     C                   MOVE      'R'           KRcv                                         CHG001
     C                   ELSE                                                                 CHG005
     C                   MOVE      'S'           KRcv                                         CHG005
     C                   ENDIF                                                                CHG005
     C****************** OPEN      SDPSTSV1                                            CHG001 JMI108
     C                   OPEN      XXPSTSV1                                                   JMI108
     C**********         OPEN      GLJEIPL1                                            CHG001 CHG002
     C**********         OPEN      GLJEIHL1                                            CHG001 CHG002
     C**********         OPEN      GLPLDTV0                                            CHG001 CHG002
      *                                                                                       CHG001
     C**** KSeqRcv       CHAIN     SDPSTSD1                           83               CHG001 JMI108
     C     KSeqRcv       CHAIN     XXPSTSD1                           83                      JMI108
      *                                                                                       CHG001
      * If record for this sequence number flagged 'Y' for success                            CHG001
      * delete corresponding records                                                          CHG001
     C     *IN83         IFEQ      *OFF                                                       CHG001
     C     JSUCC         ANDEQ     'Y'                                                        CHG001
      *                                                                                       CHG002
     C                   OPEN      GLJEIPL1                                                   CHG002
     C                   OPEN      GLJEIHL1                                                   CHG002
     C****************** OPEN      GLPLDTV0                                            CHG002 JMI108
     C                   OPEN      XXPLDTV0                                                   JMI108
      *                                                                                       CHG001
     C                   MOVE      JIBTCH        KBTNB             3                          CHG001
     C                   Z-ADD     0             KBINB             3 0                        CHG001
     C     KJEIP         SETLL     GLJEIPL1                                                   CHG001
     C     KBTNB         READE     GLJEIPL1                               83                  CHG001
     C     *IN83         DOWNE     *ON                                                        CHG001
      *                                                                                       CHG001
     C                   DELETE    @POST2                                                     CHG001
      *                                                                                       CHG001
     C     KBTNB         READE     GLJEIPL1                               83                  CHG001
     C                   ENDDO                                                                CHG001
      *                                                                                       CHG001
     C     KBTNB         CHAIN     GLJEIHL1                           83                      CHG001
     C     *IN83         IFEQ      *OFF                                                       CHG001
     C                   DELETE    @BRREAH                                                    CHG001
     C                   ENDIF                                                                CHG001
      *                                                                                       CHG001
     C**** NAlpha        SETLL     GLPLDTV0                                            CHG001 JMI108
     C**** NAlpha        READE     GLPLDTD0                               83           CHG001 JMI108
     C     NAlpha        SETLL     XXPLDTV0                                                   JMI108
     C     NAlpha        READE     XXPLDTD0                               83                  JMI108
     C     *IN83         DOWNE     *ON                                                        CHG001
      *                                                                                       CHG001
     C****************** DELETE    GLPLDTD0                                            CHG001 JMI108
     C                   DELETE    XXPLDTD0                                                   JMI108
      *                                                                                       CHG001
     C**** NAlpha        READE     GLPLDTD0                               83           CHG001 JMI108
     C     NAlpha        READE     XXPLDTD0                               83                  JMI108
     C                   ENDDO                                                                CHG001
      *                                                                                       CHG001
     C****************** DELETE    SDPSTSD1                                            CHG001 JMI108
     C                   DELETE    XXPSTSD1                                                   JMI108
      *                                                                                       CHG001
     C                   CLOSE     GLJEIPL1                                                   CHG001
     C                   CLOSE     GLJEIHL1                                                   CHG001
     C****************** CLOSE     GLPLDTV0                                            CHG001 JMI108
     C                   CLOSE     XXPLDTV0                                                   JMI108
     C                   ENDIF                                                                CHG001
      *                                                                                       CHG001
     C****************** CLOSE     SDPSTSV1                                            CHG001 JMI108
     C                   CLOSE     XXPSTSV1                                                   JMI108
      *                                                                                       CHG001
     C                   ENDSR                                                                CHG001
      /EJECT
      *****************************************************************
     C     Set_FTPIn     BEGSR
      *
     C****************** OPEN      GLPMINPP                                     JMI108
     C                   OPEN      XXPMINPP                                     JMI108
      *
      ***Write*user*id*for*Transfer Request to PF/GLPMINPP*************         JMI108
      ** Write user id for Transfer Request to PF/XXPMINPP                      JMI108
     C                   MOVE      *BLANKS       @USRID                                       CHG003
     C                   MOVEL     JUSER         USER
     C                   MOVEL     JPWORD        PASW
      *
     C                   CLEAR                   JMIDTA
     C                   MOVEL     @USRID        JMIDTA
     C****************** WRITE     GLPMIND0                                     JMI108
     C                   WRITE     XXPMIND0                                     JMI108
      *                                                                                       CHG007
      ** Write 'cd ..' transfer request to PF/GLPMINPP                                        CHG007
      *                                                                                       CHG007
     C                   CLEAR                   JMIDTA                                       CHG007
     C                   MOVEL     'cd ..'       JMIDTA                                       CHG007
     C****************** WRITE     GLPMIND0                                            CHG007 JMI108
     C                   WRITE     XXPMIND0                                                   JMI108

      ** Set up fields for transfer request to be written.
     C                   MOVEL     'GET'         GET
     C                   MOVEL     *BLANKS       @1
      *
     C                   MOVE      *BLANKS       PATH
      *
     C                   MOVEL     '(REPLACE'    REPLC
     C                   MOVEL     *BLANKS       @3
     C                   MOVEL     '/'           @4
      *
      * Set up file name and sequence number
     C                   MOVEA     *BLANKS       File_Name                                    CHG003
     C                   MOVEA     JIFILE        File_Name
      *
      * Need to add sequence number to end of file, file could
      * be any number of letters
     C                   Z-ADD     1             Y                 2 0
     C     File_Name(Y)  DOUEQ     ' '
     C     File_Name(Y)  IFNE      ' '
     C                   ADD       1             Y
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVE      NAlpha        X_Alpha           3
     C                   MOVEA     X_Alpha       File_Name(Y)

     C                   MOVEA     *BLANKS       PATHA                                        CHG003
     C                   MOVEA     JDIR          PATHA

     C                   Z-ADD     1             Y
     C     PATHA(Y)      DOWNE     ' '
     C                   ADD       1             Y
     C                   ENDDO
      *
     C**********         MOVE      '/'           PATHA(Y)                                     CHG007
     C**********         ADD       1             Y                                            CHG007
     C                   MOVEA     File_Name     PATHA(Y)
      *
     C                   MOVEA     PATHA         PATH
      *
     C                   MOVEA     File_Name     FILNM
      ** Library name, system prefix from SDSTAT
     C     LIBR          CAT       'DMLIB'       @LIB              7
     C                   MOVE      @LIB          LIBNM
      *
      ** Output to file.
      *
     C                   CLEAR                   JMIDTA
     C                   MOVEL     @GET          JMIDTA
     C****************** WRITE     GLPMIND0                                     JMI108
     C                   WRITE     XXPMIND0                                     JMI108

      ** Write quit for transfer request to PF/GLPMINPP
     C                   CLEAR                   JMIDTA
     C                   MOVEL     'QUIT'        JMIDTA
     C****************** WRITE     GLPMIND0                                     JMI108
     C                   WRITE     XXPMIND0                                     JMI108
      *
     C****************** CLOSE     GLPMINPP                                     JMI108
     C                   CLOSE     XXPMINPP                                     JMI108
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     Set_FTPout    BEGSR
      *
     C****************** OPEN      GLPMINPP                                     JMI108
     C                   OPEN      XXPMINPP                                     JMI108

      ** Write user id for Transfer Request to PF/GLPMINPP
     C                   MOVE      *BLANKS       @USRID                                       CHG003
     C                   MOVEL     JUSER         USER
     C                   MOVEL     *BLANKS       @6
     C                   MOVEL     JPWORD        PASW
      *
     C                   CLEAR                   JMIDTA
     C                   MOVEL     @USRID        JMIDTA
     C****************** WRITE     GLPMIND0                                     JMI108
     C                   WRITE     XXPMIND0                                     JMI108
      *                                                                                       CHG007
      ** Write 'cd ..' transfer request to PF/GLPMINPP                                        CHG007
      *                                                                                       CHG007
     C                   CLEAR                   JMIDTA                                       CHG007
     C                   MOVEL     'cd ..'       JMIDTA                                       CHG007
     C****************** WRITE     GLPMIND0                                            CHG007 JMI108
     C                   WRITE     XXPMIND0                                                   JMI108
      *
      ** Set up fields for transfer request to be written.
     C                   MOVEL     'PUT'         PUT
     C                   MOVEL     *BLANKS       @6
      *
     C                   MOVE      *BLANKS       PATHO
      *
     C                   MOVEL     *BLANKS       @8
     C                   MOVEL     '/'           @7
      *
      * Set up file name and sequence number
     C                   MOVEA     *BLANKS       File_Name                                    CHG003
     C                   MOVEA     JOIAB         File_Name
      *
      * Need to add sequence number to end of file, file could
      * be any number of letters
     C                   Z-ADD     1             Y                 2 0
     C     File_Name(Y)  DOUEQ     ' '
     C     File_Name(Y)  IFNE      ' '
     C                   ADD       1             Y
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVE      NAlpha        X_Alpha           3
     C                   MOVEA     X_Alpha       File_Name(Y)
      ** Library name, system prefix from SDSTAT
     C     LIBR          CAT       'DMLIB'       @LIB              7
     C                   MOVE      @LIB          LIBNMO
      *
      ** If intra-day file
     C                   IF        N >= 1 AND
     C                             N <= 20
     C                   MOVEA     File_Name     FILNMO
     C                   ENDIF
     C                   IF        NAlpha = 'FID'
     C                   MOVEL     JOPFAB        FILNMO
     C                   ENDIF
     C                   IF        NAlpha = 'REC'
     C                   MOVEL     JOPREC        FILNMO
     C                   ENDIF
     C                   IF        NAlpha = 'COB'
     C                   MOVEL     JOPCAB        FILNMO
     C                   ENDIF
      *
     C                   MOVEA     *BLANKS       PATHA                                        CHG003
     C                   MOVEA     JDIR          PATHA
      *
     C                   Z-ADD     1             Y
     C     PATHA(Y)      DOWNE     ' '
     C                   ADD       1             Y
     C                   ENDDO
      *
     C**********         MOVE      '/'           PATHA(Y)                                     CHG007
     C**********         ADD       1             Y                                            CHG007
     C                   MOVEA     File_Name     PATHA(Y)
      *
     C                   MOVEA     PATHA         PATHO
      *
      ** Output to file.
      *
     C                   CLEAR                   JMIDTA
     C                   MOVEL     @PUT          JMIDTA
     C****************** WRITE     GLPMIND0                                     JMI108
     C                   WRITE     XXPMIND0                                     JMI108

      ***Write*quit*for*transfer*request to PF/GLPRINPP                         JMI108
      ** Write quit for transfer request to PF/XXPMINPP                         JMI108
     C                   CLEAR                   JMIDTA
     C                   MOVEL     'QUIT'        JMIDTA
     C****************** WRITE     GLPMIND0                                     JMI108
     C                   WRITE     XXPMIND0                                     JMI108
      *
     C****************** CLOSE     GLPMINPP                                     JMI108
     C                   CLOSE     XXPMINPP                                     JMI108

     C                   ENDSR
      /EJECT
      *****************************************************************
     C     VALID         BEGSR
      *
      ** Clear error conditioning fields
      *
     C                   EVAL      P0RTN = *BLANKS
     C                   EVAL      ERR = 'N'
     C                   SETON                                        30
      *
      ** Validate screen fields
      *
     C                   EXSR      PROCESS
      *                                                                                       CHG006
      ** Allocate Files before calling GL106                                                  CHG006
     C****************** CALL      'GLCJ106'                                           CHG006 JMI108
     C                   CALL      'XXCJ116'                                                  JMI108
     C                   PARM      *BLANKS       @RtCd                                        CHG006
                                                                                              CHG006
     C                   IF        RetryOK = 'Y'
     C                   IF        @Rtcd   = '       '                                        CHG006
     C                   SETON                                        81
     C                   EVAL      ZAMSID = 'XXX1144'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   ELSE                                                                 CHG006
     C                   EVAL      ZAMSID = 'XXX1145'                                         CHG006
     C                   EVAL      ZAMSGF = 'XXUSRMSG'                                        CHG006
     C                   EXSR      ZASNMS                                                     CHG006
     C                   ENDIF                                                                CHG006
     C                   SETON                                        99
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   EVAL      RetryOK = 'N'
     C                   EXSR      SRProtect
      *
     C                   ENDIF
      *
     C                   IF        *IN21 = '1'
     C                   EXSR      SRDeleteDt                                                 CHG001
     C                   EXSR      SRFTPGo
     C                   EVAL      ERR = 'Y'
     C                   SETON                                        30
     C                   EXSR      RESET
     C                   ENDIF
                                                                                              CHG006
     C                   CALL      'QCMDEXC'                                                  CHG006
     C                   PARM                    PCommand4                                    CHG006
     C                   PARM                    PCommandLen3                                 CHG006
                                                                                              CHG006
     C                   CALL      'QCMDEXC'                                                  TFJ11A
     C                   PARM                    PCommand5                                    TFJ11A
     C                   PARM                    PCommandLen3                                 TFJ11A
                                                                                              TFJ11A
      *
      ** Error detected?
      *
     C                   IF        ERR = 'Y'
     C                   SETOFF                                           30
     C                   ENDIF
      *
      ** Reset global error indicator
     C                   SETOFF                                           99    *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SRSavSts      BEGSR
      *
     C****************** OPEN      SDPSTSV1                                     JMI108
     C                   OPEN      XXPSTSV1                                     JMI108
     C                   EVAL      KSeq = NAlpha
     C                   EVAL      KRcv = 'R'
     C**** KSeqRcv       CHAIN     SDPSTSD1                           83        JMI108
     C     KSeqRcv       CHAIN     XXPSTSD1                           83        JMI108
     C                   IF        *IN83 = *OFF
     C                   EVAL      JSUCC = 'Y'
     C****************** UPDATE    SDPSTSD1                                     JMI108
     C                   UPDATE    XXPSTSD1                                     JMI108
     C                   ENDIF
     C****************** CLOSE     SDPSTSV1                                     JMI108
     C                   CLOSE     XXPSTSV1                                     JMI108
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     CLRIND        BEGSR
      *
     C                   SETOFF                                       313233
     C                   SETOFF                                       343536
     C                   SETOFF                                       373839
     C                   SETOFF                                       404142
     C                   SETOFF                                       434445
     C                   SETOFF                                       464748
     C                   SETOFF                                       495051
     C                   SETOFF                                       525354
     C                   SETOFF                                       555657
     C                   SETOFF                                       585960
     C                   SETOFF                                       86
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SRTimeDtl     BEGSR
      *
      ***Move*SDPICDPP*fields*to*screen**************                           JMI108
      ** Move XXPICDPP fields to screen                                         JMI108
      ** and determine the FTP status
      *
      * Incoming FTP time
     C                   IF        *IN87 = *ON
     C                   EVAL      KType = 'R'
      *
     C                   IF        JPITM1 <> *BLANKS
     C                   MOVE      JPITM1        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM1
     C                   EVAL      KSeq = '001'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP1 = 'SCHD'
     C                   SETON                                        61
     C                   MOVEA     1             InProtInd(1)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP1 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE1 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        61
     C                   MOVEA     1             InProtInd(1)
     C                   ENDIF
      *
     C                   IF        JPITM2 <> *BLANKS
     C                   MOVE      JPITM2        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM2
     C                   EVAL      KSeq = '002'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP2 = 'SCHD'
     C                   SETON                                        62
     C                   MOVEA     1             InProtInd(2)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP2 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE2 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        62
     C                   MOVEA     1             InProtInd(2)
     C                   ENDIF
      *
     C                   IF        JPITM3 <> *BLANKS
     C                   MOVE      JPITM3        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM3
     C                   EVAL      KSeq = '003'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP3 = 'SCHD'
     C                   SETON                                        63
     C                   MOVEA     1             InProtInd(3)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP3 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE3 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        63
     C                   MOVEA     1             InProtInd(3)
     C                   ENDIF
      *
     C                   IF        JPITM4 <> *BLANKS
     C                   MOVE      JPITM4        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM4
     C                   EVAL      KSeq = '004'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP4 = 'SCHD'
     C                   SETON                                        64
     C                   MOVEA     1             InProtInd(4)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP4 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE4 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        64
     C                   MOVEA     1             InProtInd(4)
     C                   ENDIF
      *
     C                   IF        JPITM5 <> *BLANKS
     C                   MOVE      JPITM5        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM5
     C                   EVAL      KSeq = '005'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP5 = 'SCHD'
     C                   SETON                                        65
     C                   MOVEA     1             InProtInd(5)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP5 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE5 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        65
     C                   MOVEA     1             InProtInd(5)
     C                   ENDIF
      *
     C                   IF        JPITM6 <> *BLANKS
     C                   MOVE      JPITM6        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM6
     C                   EVAL      KSeq = '006'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP6 = 'SCHD'
     C                   SETON                                        66
     C                   MOVEA     1             InProtInd(6)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP6 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE6 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        66
     C                   MOVEA     1             InProtInd(6)
     C                   ENDIF
      *
     C                   IF        JPITM7 <> *BLANKS
     C                   MOVE      JPITM7        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM7
     C                   EVAL      KSeq = '007'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP7 = 'SCHD'
     C                   SETON                                        67
     C                   MOVEA     1             InProtInd(7)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP7 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE7 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        67
     C                   MOVEA     1             InProtInd(7)
     C                   ENDIF
      *
     C                   IF        JPITM8 <> *BLANKS
     C                   MOVE      JPITM8        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM8
     C                   EVAL      KSeq = '008'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP8 = 'SCHD'
     C                   SETON                                        68
     C                   MOVEA     1             InProtInd(8)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP8 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE8 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        68
     C                   MOVEA     1             InProtInd(8)
     C                   ENDIF
      *
     C                   IF        JPITM9 <> *BLANKS
     C                   MOVE      JPITM9        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM9
     C                   EVAL      KSeq = '009'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP9 = 'SCHD'
     C                   SETON                                        69
     C                   MOVEA     1             InProtInd(9)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP9 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE9 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        69
     C                   MOVEA     1             InProtInd(9)
     C                   ENDIF
      *
     C                   IF        JPITM10 <> *BLANKS
     C                   MOVE      JPITM10       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM10
     C                   EVAL      KSeq = '010'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP10 = 'SCHD'
     C                   SETON                                        70
     C                   MOVEA     1             InProtInd(10)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP10 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE10 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        70
     C                   MOVEA     1             InProtInd(10)
     C                   ENDIF
      *
     C                   IF        JPITM11 <> *BLANKS
     C                   MOVE      JPITM11       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM11
     C                   EVAL      KSeq = '011'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP11 = 'SCHD'
     C                   SETON                                        71
     C                   MOVEA     1             InProtInd(11)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP11 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE11 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        71
     C                   MOVEA     1             InProtInd(11)
     C                   ENDIF
      *
     C                   IF        JPITM12 <> *BLANKS
     C                   MOVE      JPITM12       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM12
     C                   EVAL      KSeq = '012'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP12 = 'SCHD'
     C                   SETON                                        72
     C                   MOVEA     1             InProtInd(12)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP12 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE12 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        72
     C                   MOVEA     1             InProtInd(12)
     C                   ENDIF
      *
     C                   IF        JPITM13 <> *BLANKS
     C                   MOVE      JPITM13       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM13
     C                   EVAL      KSeq = '013'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP13 = 'SCHD'
     C                   SETON                                        73
     C                   MOVEA     1             InProtInd(13)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP13 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE13 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        73
     C                   MOVEA     1             InProtInd(13)
     C                   ENDIF
      *
     C                   IF        JPITM14 <> *BLANKS
     C                   MOVE      JPITM14       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM14
     C                   EVAL      KSeq = '014'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP14 = 'SCHD'
     C                   SETON                                        74
     C                   MOVEA     1             InProtInd(14)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP14 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE14 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        74
     C                   MOVEA     1             InProtInd(14)
     C                   ENDIF
      *
     C                   IF        JPITM15 <> *BLANKS
     C                   MOVE      JPITM15       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM15
     C                   EVAL      KSeq = '015'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP15 = 'SCHD'
     C                   SETON                                        75
     C                   MOVEA     1             InProtInd(15)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP15 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE15 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        75
     C                   MOVEA     1             InProtInd(15)
     C                   ENDIF
      *
     C                   IF        JPITM16 <> *BLANKS
     C                   MOVE      JPITM16       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM16
     C                   EVAL      KSeq = '016'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP16 = 'SCHD'
     C                   SETON                                        76
     C                   MOVEA     1             InProtInd(16)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP16 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE16 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        76
     C                   MOVEA     1             InProtInd(16)
     C                   ENDIF
      *
     C                   IF        JPITM17 <> *BLANKS
     C                   MOVE      JPITM17       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM17
     C                   EVAL      KSeq = '017'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP17 = 'SCHD'
     C                   SETON                                        77
     C                   MOVEA     1             InProtInd(17)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP17 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE17 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        77
     C                   MOVEA     1             InProtInd(17)
     C                   ENDIF
      *
     C                   IF        JPITM18 <> *BLANKS
     C                   MOVE      JPITM18       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM18
     C                   EVAL      KSeq = '018'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP18 = 'SCHD'
     C                   SETON                                        78
     C                   MOVEA     1             InProtInd(18)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP18 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE18 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        78
     C                   MOVEA     1             InProtInd(18)
     C                   ENDIF
      *
     C                   IF        JPITM19 <> *BLANKS
     C                   MOVE      JPITM19       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM19
     C                   EVAL      KSeq = '019'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP19 = 'SCHD'
     C                   SETON                                        79
     C                   MOVEA     1             InProtInd(19)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP19 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE19 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        79
     C                   MOVEA     1             InProtInd(19)
     C                   ENDIF
      *
     C                   IF        JPITM20 <> *BLANKS
     C                   MOVE      JPITM20       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RITIM20
     C                   EVAL      KSeq = '020'
     C**** KSeqRcv       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqRcv       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      RIFTP20 = 'SCHD'
     C                   SETON                                        80
     C                   MOVEA     1             InProtInd(20)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP20 = V@FTP
      * Set Journal Entries Interface status
     C                   EXSR      SRSetJE
     C                   EVAL      RIIFJE20 = WIFJE
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        80
     C                   MOVEA     1             InProtInd(20)
     C                   ENDIF
      *
     C                   ENDIF
      * Outgoing FTP time
     C                   IF        *IN87 = *OFF
      *
     C                   IF        JPOTM1 <> *BLANKS
     C                   MOVE      JPOTM1        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM1
     C                   EVAL      KSeq = '001'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP1 = 'SCHD'
     C                   SETON                                        61
     C                   MOVEA     1             OutProtInd(1)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP1 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        61
     C                   MOVEA     1             OutProtInd(1)
     C                   ENDIF
      *
     C                   IF        JPOTM2 <> *BLANKS
     C                   MOVE      JPOTM2        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM2
     C                   EVAL      KSeq = '002'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP2 = 'SCHD'
     C                   SETON                                        62
     C                   MOVEA     1             OutProtInd(2)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP2 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        62
     C                   MOVEA     1             OutProtInd(2)
     C                   ENDIF
      *
     C                   IF        JPOTM3 <> *BLANKS
     C                   MOVE      JPOTM3        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM3
     C                   EVAL      KSeq = '003'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP3 = 'SCHD'
     C                   SETON                                        63
     C                   MOVEA     1             OutProtInd(3)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP3 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        63
     C                   MOVEA     1             OutProtInd(3)
     C                   ENDIF
      *
     C                   IF        JPOTM4 <> *BLANKS
     C                   MOVE      JPOTM4        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM4
     C                   EVAL      KSeq = '004'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP4 = 'SCHD'
     C                   SETON                                        64
     C                   MOVEA     1             OutProtInd(4)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP4 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        64
     C                   MOVEA     1             OutProtInd(4)
     C                   ENDIF
      *
     C                   IF        JPOTM5 <> *BLANKS
     C                   MOVE      JPOTM5        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM5
     C                   EVAL      KSeq = '005'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP5 = 'SCHD'
     C                   SETON                                        65
     C                   MOVEA     1             OutProtInd(5)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP5 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        65
     C                   MOVEA     1             OutProtInd(5)
     C                   ENDIF
      *
     C                   IF        JPOTM6 <> *BLANKS
     C                   MOVE      JPOTM6        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM6
     C                   EVAL      KSeq = '006'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP6 = 'SCHD'
     C                   SETON                                        66
     C                   MOVEA     1             OutProtInd(6)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP6 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        66
     C                   MOVEA     1             OutProtInd(6)
     C                   ENDIF
      *
     C                   IF        JPOTM7 <> *BLANKS
     C                   MOVE      JPOTM7        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM7
     C                   EVAL      KSeq = '007'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP7 = 'SCHD'
     C                   SETON                                        67
     C                   MOVEA     1             OutProtInd(7)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP7 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        67
     C                   MOVEA     1             OutProtInd(7)
     C                   ENDIF
      *
     C                   IF        JPOTM8 <> *BLANKS
     C                   MOVE      JPOTM8        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM8
     C                   EVAL      KSeq = '008'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP8 = 'SCHD'
     C                   SETON                                        68
     C                   MOVEA     1             OutProtInd(8)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP8 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        68
     C                   MOVEA     1             OutProtInd(8)
     C                   ENDIF
      *
     C                   IF        JPOTM9 <> *BLANKS
     C                   MOVE      JPOTM9        ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM9
     C                   EVAL      KSeq = '009'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP9 = 'SCHD'
     C                   SETON                                        69
     C                   MOVEA     1             OutProtInd(9)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP9 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        69
     C                   MOVEA     1             OutProtInd(9)
     C                   ENDIF
      *
     C                   IF        JPOTM10 <> *BLANKS
     C                   MOVE      JPOTM10       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM10
     C                   EVAL      KSeq = '010'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP10 = 'SCHD'
     C                   SETON                                        70
     C                   MOVEA     1             OutProtInd(10)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP10 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        70
     C                   MOVEA     1             OutProtInd(10)
     C                   ENDIF
      *
     C                   IF        JPOTM11 <> *BLANKS
     C                   MOVE      JPOTM11       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM11
     C                   EVAL      KSeq = '011'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP11 = 'SCHD'
     C                   SETON                                        71
     C                   MOVEA     1             OutProtInd(11)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP11 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        71
     C                   MOVEA     1             OutProtInd(11)
     C                   ENDIF
      *
     C                   IF        JPOTM12 <> *BLANKS
     C                   MOVE      JPOTM12       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM12
     C                   EVAL      KSeq = '012'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP12 = 'SCHD'
     C                   SETON                                        72
     C                   MOVEA     1             OutProtInd(12)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP12 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        72
     C                   MOVEA     1             OutProtInd(12)
     C                   ENDIF
      *
     C                   IF        JPOTM13 <> *BLANKS
     C                   MOVE      JPOTM13       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM13
     C                   EVAL      KSeq = '013'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP13 = 'SCHD'
     C                   SETON                                        73
     C                   MOVEA     1             OutProtInd(13)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP13 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        73
     C                   MOVEA     1             OutProtInd(13)
     C                   ENDIF
      *
     C                   IF        JPOTM14 <> *BLANKS
     C                   MOVE      JPOTM14       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM14
     C                   EVAL      KSeq = '014'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP14 = 'SCHD'
     C                   SETON                                        74
     C                   MOVEA     1             OutProtInd(14)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP14 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        74
     C                   MOVEA     1             OutProtInd(14)
     C                   ENDIF
      *
     C                   IF        JPOTM15 <> *BLANKS
     C                   MOVE      JPOTM15       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM15
     C                   EVAL      KSeq = '015'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP15 = 'SCHD'
     C                   SETON                                        75
     C                   MOVEA     1             OutProtInd(15)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP15 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        75
     C                   MOVEA     1             OutProtInd(15)
     C                   ENDIF
      *
     C                   IF        JPOTM16 <> *BLANKS
     C                   MOVE      JPOTM16       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM16
     C                   EVAL      KSeq = '016'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP16 = 'SCHD'
     C                   SETON                                        76
     C                   MOVEA     1             OutProtInd(16)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP16 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        76
     C                   MOVEA     1             OutProtInd(16)
     C                   ENDIF
      *
     C                   IF        JPOTM17 <> *BLANKS
     C                   MOVE      JPOTM17       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM17
     C                   EVAL      KSeq = '017'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP17 = 'SCHD'
     C                   SETON                                        77
     C                   MOVEA     1             OutProtInd(17)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP17 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        77
     C                   MOVEA     1             OutProtInd(17)
     C                   ENDIF
      *
     C                   IF        JPOTM18 <> *BLANKS
     C                   MOVE      JPOTM18       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM18
     C                   EVAL      KSeq = '018'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP18 = 'SCHD'
     C                   SETON                                        78
     C                   MOVEA     1             OutProtInd(18)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP18 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        78
     C                   MOVEA     1             OutProtInd(18)
     C                   ENDIF
      *
     C                   IF        JPOTM19 <> *BLANKS
     C                   MOVE      JPOTM19       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM19
     C                   EVAL      KSeq = '019'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP19 = 'SCHD'
     C                   SETON                                        79
     C                   MOVEA     1             OutProtInd(19)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP19 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        79
     C                   MOVEA     1             OutProtInd(19)
     C                   ENDIF
      *
     C                   IF        JPOTM20 <> *BLANKS
     C                   MOVE      JPOTM20       ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROTIM20
     C                   EVAL      KSeq = '020'
     C**** KSeqSnt       CHAIN     SDPSTSV0                           27        JMI108
     C     KSeqSnt       CHAIN     XXPSTSV0                           27        JMI108
     C                   IF        *IN27 = *ON
     C                   EVAL      ROFTP20 = 'SCHD'
     C                   SETON                                        80
     C                   MOVEA     1             OutProtInd(20)
     C                   ELSE
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFTP20 = V@FTP
     C                   ENDIF
     C                   ELSE
     C                   SETON                                        80
     C                   MOVEA     1             OutProtInd(20)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     C     SRStsDtl      BEGSR
      *
      ** Move Status details to screen
      *
     C**** *LOVAL        SETLL     SDPSTSV0                                     JMI108
     C****               READ      SDPSTSV0                               26    JMI108
     C     *LOVAL        SETLL     XXPSTSV0                                     JMI108
     C                   READ      XXPSTSV0                               26    JMI108
      *
     C                   DOW       *IN26 = *OFF
      ** Look for all records with file sequence 'R'(Receive) status
     C                   IF        V0_JTYPE = 'R'
     C                   EVAL      KType = 'R'
     C                   SELECT
     C                   WHEN      V0_JNUM = '001'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp1 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP1 = V@FTP
      *
     C                   WHEN      V0_JNUM = '002'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp2 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP2 = V@FTP
      *
     C                   WHEN      V0_JNUM = '003'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp3 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP3 = V@FTP
      *
     C                   WHEN      V0_JNUM = '004'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp4 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP4 = V@FTP
      *
     C                   WHEN      V0_JNUM = '005'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp5 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP5 = V@FTP
      *
     C                   WHEN      V0_JNUM = '006'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp6 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP6 = V@FTP
      *
     C                   WHEN      V0_JNUM = '007'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp7 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP7 = V@FTP
      *
     C                   WHEN      V0_JNUM = '008'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp8 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP8 = V@FTP
      *
     C                   WHEN      V0_JNUM = '009'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp9 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP9 = V@FTP
      *
     C                   WHEN      V0_JNUM = '010'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp10 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP10 = V@FTP
      *
     C                   WHEN      V0_JNUM = '011'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp11 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP11 = V@FTP
      *
     C                   WHEN      V0_JNUM = '012'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp12 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP12 = V@FTP
      *
     C                   WHEN      V0_JNUM = '013'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp13 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP13 = V@FTP
      *
     C                   WHEN      V0_JNUM = '014'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp14 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP14 = V@FTP
      *
     C                   WHEN      V0_JNUM = '015'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp15 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP15 = V@FTP
      *
     C                   WHEN      V0_JNUM = '016'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp16 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP16 = V@FTP
      *
     C                   WHEN      V0_JNUM = '017'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp17 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP17 = V@FTP
      *
     C                   WHEN      V0_JNUM = '018'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp18 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP18 = V@FTP
      *
     C                   WHEN      V0_JNUM = '019'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp19 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP19 = V@FTP
      *
     C                   WHEN      V0_JNUM = '020'
     C                   EVAL      P@InsTyp = V0_JINST
     C                   EXSR      SRDesc
     C                   EVAL      RITyp20 = V@Desc
     C                   EXSR      SRFTPSts
     C                   EVAL      RIFTP20 = V@FTP
      *
     C                   ENDSL
      *
     C                   ENDIF
     C****************** READ      SDPSTSV0                               26    JMI108
     C                   READ      XXPSTSV0                               26    JMI108
      *
     C                   ENDDO
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SRDesc        BEGSR
      *
      ** Determine Instruction type description
      *
     C                   EVAL      V@Desc = *Blanks
     C                   SELECT
      ** Pooling
     C                   WHEN      P@InsTyp = '001'
     C                   EVAL      V@Desc = 'POL'
      ** Sweep
     C                   WHEN      P@InsTyp = '002'
     C                   EVAL      V@Desc = 'SWP'
      ** Reversal entries
     C                   WHEN      P@InsTyp = '003'
     C                   EVAL      V@Desc = 'REV'
      ** Pooling commission
     C                   WHEN      P@InsTyp = '004'
     C                   EVAL      V@Desc = 'PCM'
      ** Sweep commission
     C                   WHEN      P@InsTyp = '005'
     C                   EVAL      V@Desc = 'SCM'
      ** Account Transfer                                                                     TFJ11A
     C                   WHEN      P@InsTyp = '006'                                           TFJ11A
     C                   EVAL      V@Desc = 'TFR'                                             TFJ11A
      ** Account Transfer Commission                                                          TFJ11A
     C                   WHEN      P@InsTyp = '007'                                           TFJ11A
     C                   EVAL      V@Desc = 'TCM'                                             TFJ11A
      *
     C                   ENDSL
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SRFTPSts      BEGSR
      *
      ** Determine FTP Status
      *
     C                   SELECT
      ** Received successfully
     C                   WHEN      V0_JSUCC = 'Y'
     C                   IF        *IN87 = *ON
     C                   EVAL      V@FTP = 'RCVD'
     C                   ELSE
     C                   EVAL      V@FTP = 'SENT'
     C                   ENDIF
      ** FTP failed
     C                   WHEN      V0_JSUCC = 'N'
     C                   EVAL      V@FTP = 'FAIL'
     C                   ENDSL
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SRSetJE       BEGSR
      *
      ** Set Journal Entries Interface status
      *
     C                   EVAL      WIFJE = *Blanks
     C                   IF        V@FTP = 'RCVD'
      *
     C                   EVAL      WDash = '-'
      *
      *  if record is not SWEEP
     C                   IF        V0_JINST <> '002'
      *
     C                   IF        V0_JIBTCH <> *BLANKS
      ** output the interface batch number
     C                   EVAL      WIBtch = V0_JIBTCH
     C                   ELSE
      ** output 'N/A' on interface batch number
     C                   EVAL      WIBtch = 'N/A'
     C                   ENDIF
      *
     C                   IF        V0_JBTCH <> *BLANKS
      ** output the batch number
     C                   EVAL      WBtch = V0_JBTCH
     C                   ELSE
      ** output 'N/A' on batch number
     C                   EVAL      WBtch = 'N/A'
     C                   ENDIF
      *
     C                   ELSE
      ** Pooling Instruction type is SWEEP
     C                   EVAL      WIFJE = 'TimeDep'
     C                   ENDIF
      *
     C                   ELSE
      ** if FTP status is either SCHD or FAIL,
      ** output 'No File'
     C                   EVAL      WIFJE = 'No File'
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     ZASNMS        BEGSR
      *
      ** Send message to program's message queue
      *
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      *
      ** If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      *
      ** Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     ZXEXPG        BEGSR
      *
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     '**CMD**'     P2RTN                          *Return code
     C                   MOVEL     'CMD01'       P3WRTC                         Work Return cod
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        P0RTN
      *
     C****************** CLOSE     GLPMINPP
     C****************** CLOSE     SDPSTSV1
     C                   CLOSE     XXPMINPP                                     JMI108
     C                   CLOSE     XXPSTSV1                                     JMI108
      ** Terminate program
     C                   SETON                                        LR
      *
      ** Exit program
     C                   RETURN
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     ZZINIT        BEGSR
      *
     C                   TIME                    ##TME
      *
     C     KSeqRcv       KLIST
     C                   KFLD                    KSeq
     C                   KFLD                    KRcv
      *
     C     KSeqSnt       KLIST
     C                   KFLD                    KSeq
     C                   KFLD                    KSnt
      *
     C     KJEIP         KLIST                                                                CHG001
     C                   KFLD                    KBTNB                                        CHG001
     C                   KFLD                    KBINB                                        CHG001
      ** Initialisation
      *
      ** Only do first time through
      *
     C                   IF        *IN01 = *OFF
      * Open files
     C****************** OPEN      SDJ103DF                                     JMI108
     C                   OPEN      XXJ103DF                                     JMI108
     C                   EVAL      ERR = 'N'
      *
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      *
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT
      *
     C**** *DTAARA       DEFINE                  SDPFTPDA                       JMI108
     C     *DTAARA       DEFINE                  XXPFTPDA                       JMI108
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  ##PGM
     C                   OUT       LDA

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MBIN          WUMBIN            1        IND Multi-branch ind.
      *  Get rundate
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
      *
     C                   IF        PRtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      * Move rundate to display
     C                   MOVEL     BJMRDT        ##MRDT
      *
     C                   EVAL      KType = 'R'
     C                   SETON                                        87
      *
     C****************** OPEN      SDPSTSV0                                     JMI108
     C                   OPEN      XXPSTSV0                                     JMI108
     C                   ENDIF
     C                   SETON                                        01
      *
     C****************** CLEAR                   SDJ103DI                       JMI108
     C****************** CLEAR                   SDJ103DO                       JMI108
     C                   CLEAR                   XXJ103DI                       JMI108
     C                   CLEAR                   XXJ103DO                       JMI108
      *
      ** Retrieve screen details through access object
     C****************** CALL      'AOPICDR0'                                   JMI108
     C                   CALL      'XXPICDR0'                                   JMI108
     C                   PARM      '        '    PRtCd
     C                   PARM      '*FIRST  '    POptn
     C**** SDPICD        PARM      SDPICD        DSSDY                          JMI108
     C     XXPICD        PARM      XXPICD        DSSDY                          JMI108
      *
      * DATABASE ERROR
      *
     C     PRtCd         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C****************** MOVEL     'SDPICDR0'    DBFILE                         JMI108
     C                   MOVEL     'XXPICDR0'    DBFILE                         ************* JMI108
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      *PSSR                                        *************
     C                   ELSE
     C                   EXSR      SRTimeDtl
     C                   ENDIF
      *
     C**** *LOCK         IN        SDPFTPDA                                     JMI108
     C****               OUT       SDPFTPDA                                     JMI108
     C     *LOCK         IN        XXPFTPDA                                     JMI108
     C                   OUT       XXPFTPDA                                     JMI108
      *
     C                   IF        *IN87 = *ON
     C                   EVAL      KType = 'R'
     C                   EXSR      SRStsDtl
     C                   ELSE
     C**** *LOVAL        SETLL     SDPSTSV0                                     JMI108
     C****               READ      SDPSTSV0                               29    JMI108
     C     *LOVAL        SETLL     XXPSTSV0                                     JMI108
     C                   READ      XXPSTSV0                               29    JMI108
      *
     C                   DOW       *IN29 = *OFF
      *
     C                   IF        V0_JTYPE = 'S'
     C                   SELECT
      *
     C                   WHEN      V0_JNUM = 'FID'
     C                   MOVE      V0_JTIME      ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROFIDT
     C                   EXSR      SRFTPSts
     C                   EVAL      ROFIDF = V@FTP
      *
     C                   WHEN      V0_JNUM = 'REC'
     C                   MOVE      V0_JTIME      ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         RORECT
     C                   EXSR      SRFTPSts
     C                   EVAL      RORECF = V@FTP
      *
     C                   WHEN      V0_JNUM = 'COB'
     C                   MOVE      V0_JTIME      ZFieldN
     C                   EXSR      SRTime
     C                   MOVE      WTime         ROCOBT
     C                   EXSR      SRFTPSts
     C                   EVAL      ROCOBF = V@FTP
      *
     C                   ENDSL
     C                   ENDIF
      *
     C****************** READ      SDPSTSV0                               29    JMI108
     C                   READ      XXPSTSV0                               29    JMI108
     C                   ENDDO
      *
     C                   ENDIF
     C                   IF        WUMBIN = 'N'
     C                   CALL      'ZVACTU'
     C                   PARM      'A'           PZactn            1
     C                   PARM                    PErr              1 0
     C                   IF        PErr <> *ZEROS
     C                   MOVEL     'USR8636'     ZAMSID
     C                   ENDIF
      *
      ** For multibranching system, branch code must be valid for
      ** the user
     C                   ENDIF
      *
      ** If error, protect all Retry fields
     C     PErr          IFEQ      1
     C                   EXSR      SRProtect
     C                   END
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SRTime        BEGSR
      *
      ** format time to HH:MM format
     C                   MOVE      HH#PITM       WHour
     C                   EVAL      WColon = ':'
     C                   MOVE      MM#PITM       WMin
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SRProtect     BEGSR
      *
      ** Protect all retry fields
     C                   SETON                                        616263
     C                   SETON                                        646566
     C                   SETON                                        676869
     C                   SETON                                        707172
     C                   SETON                                        737475
     C                   SETON                                        767778
     C                   SETON                                        7980
     C                   SETON                                        545556
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SRUnProt      BEGSR
      *
      ** Unprotect all retry fields
     C                   SETOFF                                       616263
     C                   SETOFF                                       646566
     C                   SETOFF                                       676869
     C                   SETOFF                                       707172
     C                   SETOFF                                       737475
     C                   SETOFF                                       767778
     C                   SETOFF                                       7980
     C                   SETOFF                                       545556
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SRProtSwtch   BEGSR
      *
      ** Disable or enable Retry fields on SCHD status
      *
     C                   IF        *IN87 = *ON
     C   05              MOVEA     InProtInd     WProtInd
     C  N05              MOVEA     OutProtInd    WProtInd
     C                   ELSE
     C   05              MOVEA     OutProtInd    WProtInd
     C  N05              MOVEA     InProtInd     WProtInd
     C                   ENDIF
      *
     C                   EVAL      X = 1
     C                   DOW       X <> 21
     C                   IF        WProtInd(X) = 1
     C                   SETON                                        82
     C                   EXSR      SRSetInd
     C                   ENDIF
     C                   IF        X < 21
     C                   EVAL      X = X + 1
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     PROCESS       BEGSR
      *
      ** If there is an error in any of the fields then we need to
      ** redisplay the screen and send all error messages
      *
     C                   MOVE      'N'           ReqOK             1
     C                   IF        *IN87 = *OFF
     C                   MOVEA     DSRetryO      ARRRetry
     C                   ELSE
     C                   MOVEA     DSRetryI      ARRRetry
     C                   ENDIF
     C                   Z-ADD     0             Z                 2 0
     C                   Z-ADD     1             X                 2 0
      *
     C                   MOVEA     ARRRetry      WAllRetry        23
     C                   IF        WAllRetry <> *BLANKS
     C                   DOW       X <> 24
      *
      * error if Retry value is not 'Y' or blank
     C                   IF        ARRRetry(X) <> 'Y' AND
     C                             ARRRetry(X) <> ' '
      *
     C                   EVAL      ZAMSID = 'XXX1142'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETOFF                                       82
     C                   EXSR      SRSetInd
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
      *
     C                   ELSE
     C                   MOVE      '000'         NAlpha            3
     C                   Z-ADD     0             N                 2 0
     C                   IF        Z <> 24
     C                   MOVE      X             Y                 2 0
     C                   IF        ARRRetry(X) = 'Y'
     C                   EVAL      N = X - 3
     C                   MOVE      N             NAlpha
     C                   EVAL      X = X + 1
     C                   DOW       X <> 24
     C                   IF        ARRRetry(X) = 'Y' AND
     C                             ReqOK = 'N'
     C                   MOVE      'Y'           ReqOK             1
     C                   ENDIF
     C                   IF        ARRRetry(X) = 'Y' AND
     C                             ReqOk = 'Y'
      *
      * error if more than one Retry is requested
     C                   EVAL      ZAMSID = 'XXX1143'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETOFF                                       82
     C                   EXSR      SRSetInd
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ELSE
     C                   IF        ARRRetry(X) <> 'Y' AND
     C                             ARRRetry(X) <> ' '
     C                   EVAL      ZAMSID = 'XXX1142'
     C                   EVAL      ZAMSGF = 'XXUSRMSG'
     C                   EXSR      ZASNMS
     C                   SETOFF                                       82
     C                   EXSR      SRSetInd
     C                   SETOFF                                       30
     C                   EVAL      ERR = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        X < 24
     C                   EVAL      X = X + 1
     C                   ENDIF
     C                   ENDDO
     C                   EVAL      Z = X
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   IF        X < 24
     C                   EVAL      X = X + 1
     C                   ENDIF
     C                   MOVE      'N'           ReqOK             1
     C                   ENDDO
      *
     C                   IF        ROFIDR = 'Y'
     C                   EVAL      NAlpha = 'FID'
     C                   ENDIF
     C                   IF        RORECR = 'Y'
     C                   EVAL      NAlpha = 'REC'
     C                   ENDIF
     C                   IF        ROCOBR = 'Y'
     C                   EVAL      NAlpha = 'COB'
     C                   ENDIF
      *
     C                   IF        ERR = 'N'
     C                   EVAL      RetryOK = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     SRSetInd      BEGSR
      *
     C                   SELECT
     C                   WHEN      X = 1
     C  N82              SETON                                        31
     C   82              SETON                                        61
     C                   WHEN      X = 2
     C  N82              SETON                                        32
     C   82              SETON                                        62
     C                   WHEN      X = 3
     C  N82              SETON                                        33
     C   82              SETON                                        63
     C                   WHEN      X = 4
     C  N82              SETON                                        34
     C   82              SETON                                        64
     C                   WHEN      X = 5
     C  N82              SETON                                        35
     C   82              SETON                                        65
     C                   WHEN      X = 6
     C  N82              SETON                                        36
     C   82              SETON                                        66
     C                   WHEN      X = 7
     C  N82              SETON                                        37
     C   82              SETON                                        67
     C                   WHEN      X = 8
     C  N82              SETON                                        38
     C   82              SETON                                        68
     C                   WHEN      X = 9
     C  N82              SETON                                        39
     C   82              SETON                                        69
     C                   WHEN      X = 10
     C  N82              SETON                                        40
     C   82              SETON                                        70
     C                   WHEN      X = 11
     C  N82              SETON                                        41
     C   82              SETON                                        71
     C                   WHEN      X = 12
     C  N82              SETON                                        42
     C   82              SETON                                        72
     C                   WHEN      X = 13
     C  N82              SETON                                        43
     C   82              SETON                                        73
     C                   WHEN      X = 14
     C  N82              SETON                                        44
     C   82              SETON                                        74
     C                   WHEN      X = 15
     C  N82              SETON                                        45
     C   82              SETON                                        75
     C                   WHEN      X = 16
     C  N82              SETON                                        46
     C   82              SETON                                        76
     C                   WHEN      X = 17
     C  N82              SETON                                        47
     C   82              SETON                                        77
     C                   WHEN      X = 18
     C  N82              SETON                                        48
     C   82              SETON                                        78
     C                   WHEN      X = 19
     C  N82              SETON                                        49
     C   82              SETON                                        79
     C                   WHEN      X = 20
     C  N82              SETON                                        50
     C   82              SETON                                        80
     C                   WHEN      X = 21
     C  N82              SETON                                        51
     C                   WHEN      X = 22
     C  N82              SETON                                        52
     C                   WHEN      X = 23
     C  N82              SETON                                        53
     C                   ENDSL
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      *
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2018
**CTDATA PCommand1
CLRPFM FILE(*LIBL/XXPMINPP)
**CTDATA PCommand2
CLRPFM FILE(*LIBL/XXPMOTPP)
**CTDATA PCommand3
CHGOBJOWN OBJ(XXXXXXXXXX) OBJTYPE(*FILE) NEWOWN(XXOWNER) CUROWNAUT(*SAME)
**CTDATA PCommand4
DLCOBJ OBJ((GLJEIPPD *FILE *EXCL))
**CTDATA PCommand5
DLCOBJ OBJ((GLJEIHPD *FILE *EXCL))
