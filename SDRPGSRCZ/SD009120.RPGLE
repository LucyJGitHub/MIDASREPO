     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Network Identification Transaction Codes')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009120 - Midas SD Network Identification Transaction Codes *
      *                                                               *
      *  Function:  This sub-file program allows the user to maintain *
      *             from a list of network ID transaction codes       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD024441           Date 21Jan14               *
      *  Prev Amend No. CGL152   *CREATE   Date 02Dec13               *
      *                                                               *
      *  MD024441 - Network Identification Transaction Codes action   *
      *             validation                                        *
      *  CGL152 - Include Transaction Type Identification Code on     *
      *           MT940/MT950                                         *
      *                                                               *
      *****************************************************************
     FSD009120DFCF   E             WORKSTN
     F                                     SFILE(SD009120S1:wRRN)
     F                                     INFDS(INFDS#)
      *
      ** DSP: Midas SD Edit Network Transaction Codes
      *
     FSDNTCDL2  IF   E           K DISK
     F                                     RENAME(SDNTCDD0:@NTCPAN)
     F                                     INFDS(INFDS1)
      *
      ** RTV: Network Identification Transaction Codes
      *
     FSDNTCDL1  UF A E           K DISK    USROPN
     F                                     RENAME(SDNTCDD0:@NTCPAM)
     F                                     COMMIT
      *
      ** UPD: Network Identification Transaction Codes
      *
     FSDNWRKL1  IF   E           K DISK    USROPN
      *
      ** RTV: Network Identification Transaction Codes
      *
     FSDNTTIPD  IF   E             DISK    USROPN
      *
      ** RTV: Network Transaction Identifier
      *
     D @CN             S             25    DIM(12) CTDATA PERRCD(1)             Long constants.
      *
      ** Description     : Copyright notice for inclusion in all programs
      *
      /EJECT
      ** Data structures:-
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      ** Program data structure.
     D JBDTTM          DS
      ** Job date/time.
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      *
      ** Display file data structure.
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      *
      ** File information data structure.
      *
     D @1DBRC        E DS                  EXTNAME(SDNTCDL1)
      *
      ** Current/previous master file format fields for change control.
      *
     D WUDELR          DS
     D  WUDR01                 1    250
     D  WUDR02               251    500
     D  WUDR03               501    750
     D  WUDR04               751   1000
     D  WUDR05              1001   1250
     D  WUDR06              1251   1500
     D  WUDR07              1501   1750
     D  WUDR08              1751   2000
     D  WUDR09              2001   2250
     D  WUDR00              2251   2500
     D  WUDR11              2501   2750
     D  WUDR12              2751   3000
      ** Outward parameters
     D PARC            DS          3064
      ** RCD : Midas SD Deleted records file retrieval
      ** I :  File name
     D  PAFNME                 1     10
      ** I :  Long Key
     D  PALKEY                11     60
      ** I :  Deleted Data Record Pt1
     D  PADR01                61    310
      ** I :  Deleted Data Record Pt2
     D  PADR02               311    560
      ** I :  Deleted Data Record Pt3
     D  PADR03               561    810
      ** I :  Deleted Data Record Pt4
     D  PADR04               811   1060
      ** I :  Deleted Data Record Pt5
     D  PADR05              1061   1310
      ** I :  Deleted Data Record Pt6
     D  PADR06              1311   1560
      ** I :  Deleted Data Record Pt7
     D  PADR07              1561   1810
      ** I :  Deleted Data Record Pt8
     D  PADR08              1811   2060
      ** I :  Deleted Data Record Pt9
     D  PADR09              2061   2310
      ** I :  Deleted Data Record Pt10
     D  PADR00              2311   2560
      ** I :  Deleted Data Record Pt11
     D  PADR11              2561   2810
      ** I :  Deleted Data Record Pt12
     D  PADR12              2811   3060
      ** I :  Last Change Date
     D  PALCD               3061   3063P 0
      ** I :  Type of Last Change
     D  PATYLC              3064   3064
     D RUNDAT          DS
     D  MRDT                   1      7                                         S01229
     D  RDNB                   8     10P 0                                      S01229
     D  SUC                   11     11                                         S01229
     D  DFF                   12     12                                         S01229
     D  MBIN                  13     13                                         S01229
     D A@CPY           DS
      ** Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Question Mark Invalid'
      * Network Transaction Code
     D  ZA0001                 1      6
      * Message data for 'Key Field Invalid Value'
      * If value in key field
     D  ZA0002                 1      1
      * Network Transaction Code
     D  ZA0003                 2      6
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
      *****************************************************************
      ** Initialise
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
      ** Initialise and load subfile page.
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      ** Display screen until reload requested:
     C     W0RSF         DOWEQ     'N'
      ** Display screen.
     C                   EXSR      CAEXFM
      ** Process response:
      ** Exit request: Cancel & exit program.
     C   03              CAS                     ZXEXPG
      ** HOME: Request subfile reload.
     C   05              CAS                     FBRQRL
      **   Display next SFL page.
     C   27              CAS                     BBLDSF
      ** Process screen input.
     C                   CAS                     DAPR##
     C                   END
      *
     C                   END                                                    OD W0RSF
     C                   END                                                    OD *HIVAL
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise & Load subfile page.
      *================================================================
      ** Clear subfile.
     C                   SETON                                        80
     C                   WRITE     SD009120C1
     C                   SETOFF                                       80
      ** Reset no of records in subfile.
     C                   Z-ADD     *ZERO         wRRNMX            5 081         SETOF 81
      ** USER: Initialise subfile header
     C                   MOVEL     @CN(01)       WUDELA                         Deletion Allowe
      ** CASE:     WRK.Set Up Complete is No
     C     WUSUC         IFEQ      @CN(01)                                      *IF
      ** CASE:     PGM.*Program mode is *CHANGE
     C     W0PMD         IFEQ      @CN(02)                                      *IF
     C                   MOVEL     @CN(03)       WUDELA                         Deletion Allowe
     C                   END                                                    *FI
     C                   END                                                    *FI
      *
      *****************************************************************
      **  Sets up the function key footer text for edit files in which
      **  records may not be deleted after the system set up flag has
      **  been set on
      *****************************************************************
      *
      **  DETAIL LINE COMMAND KEY TEXT
      *
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
      *
      ** If program mode is ADD:
      *
     C     W0PMD         IFEQ      'ADD'
      *
      ** Setup footer text:
      ** F3=Main Menu   F5=Refresh   F9=Go to 'Change' Mode
      *
     C                   MOVEL     'USR3349'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
      *
     C     *IN90         IFEQ      '1'
      ** Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
      ** Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   ELSE
      *
      ** If set up is not complete:
      *
     C     WUSUC         IFEQ      'N'
      *
      ** Setup footer text:
      ** D=Delete   F3=Main Menu   F5=Refresh   F9=Go to 'Add' Mode
      *
     C                   MOVEL     'USR3348'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
      *
     C     *IN90         IFEQ      '1'
      ** Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
      ** Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   ELSE
      *
      ** Setup footer text:
      ** F3=Main Menu   F5=Refresh   F9=Go to 'Add' Mode
      *
     C                   MOVEL     'USR3354'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
      *
     C     *IN90         IFEQ      '1'
      ** Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
      ** Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C                   END
      ** If CHANGE mode, then position file:
     C     W0PMD         IFNE      'ADD'
     C     *LIKE         DEFINE    #2NWRK        WZNWRK
     C                   MOVEL     #2NWRK        WZNWRK
     C     *LIKE         DEFINE    #2TRCD        WZTRCD
     C                   MOVEL     #2TRCD        WZTRCD
     C     KPOS          KLIST
     C                   KFLD                    NTNWRK
     C                   KFLD                    NTTRCD
      ** Setup key.
     C                   MOVEL     #2NWRK        NTNWRK                         Netw Code
     C                   MOVEL     #2TRCD        NTTRCD                         Trnx Code
     C     KPOS          SETLL     @NTCPAN                            82        *82=EOF
     C  N82              READ      @NTCPAN                              9182    *82=EOF
     C                   ELSE
     C                   SETOFF                                       82        *
     C                   END
      ** Load subfile page.
     C                   EXSR      BBLDSF
      ** If no records found, display error message.
     C   82wRRN          IFEQ      *ZERO                                        IF
      ** Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI wRRN = *ZERO
      *
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBLDSF        BEGSR
      *================================================================
      ** Load subfile page (write empty page if add mode).
      *================================================================
     C                   SETOFF                                       84        No SFLNXTCHG
      ** Re-establish fields in read-ahead record.
     C   27W0PMD         IFNE      'ADD'
     C  N82              READP     @NTCPAN                                90    *
     C  N82              READ      @NTCPAN                                90    *
     C                   END
      *
      ** Setof record error indicators.
      *
     C                   MOVE      *ALL'0'       WKIND0            4
     C                   MOVE      *ALL'1'       WKIND1            4
      ** Start at previous highest SFL record reached.
     C                   Z-ADD     wRRNMX        wRRN              5 0
     C                   Z-ADD     *ZERO         wRRNOK            5 0
      ** Load next page of SFL:
     C  N82wRRNOK        DOWLT     ##SFPG                                       DO
     C                   MOVEA     WKIND0        *IN(32)
     C                   SETOFF                                       87        *
      ** Clear SFL fields.
     C                   EXSR      MAIZ#1
      ** If change mode, load SFL fields.
     C     W0PMD         IFNE      'ADD'
     C                   EXSR      MBFL#1
      ** Validate subfile record and calculate derived fields.
     C                   EXSR      DFV2RC
     C                   END
      ** Output to subfile.
     C                   ADD       1             wRRN                 81        *
     C                   ADD       1             wRRNOK
      ** Set screen conditioning indicators.
     C                   EXSR      GADSA1
     C                   WRITE     SD009120S1
     C     W0PMD         IFNE      'ADD'
     C                   READ      @NTCPAN                                82    *82=EOF
     C                   END
     C  N82              END                                                    OD 1 - #SFPG
      ** Save highest SFL rec, so load can continue at end point.
     C     wRRN          IFGT      wRRNMX
     C     wRRNMX        ADD       1             ##SFRC
     C                   Z-ADD     wRRN          wRRNMX
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      ** Display screen and process HELP requests.
      *================================================================
      ** Set screen conditioning indicators.
     C                   EXSR      GBDSA2
      ** Update screen time.
     C                   TIME                    ##TME                          Screen time.
     C     W0HLP         DOUEQ     'N'
      ** PUTOVR unless conditioned fields change.
     C                   SETON                                        86
     C     *IN89         IFNE      CAIN89
     C     *IN81         ORNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN89         CAIN89            1
     C                   MOVE      *IN81         CAIN81            1
     C                   WRITE     SDMSGCTL
     C                   WRITE     SDCMDTXT1
     C                   EXFMT     SD009120C1
     C                   MOVEL     'N'           W0HLP             1            Reset help requ
      ** If help requested, display help text.
     C   25              EXSR      ZHHPKY                                       Display help te
     C                   END
      ** Update job time.
     C                   TIME                    ##JTM                          Job time.
      ** Clear messages from program message queue.
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      ** Reset first message only flag.
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPR##        BEGSR
      *================================================================
      ** Process screen input.
      *================================================================
      ** Maintain subfile position where possible.
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      *
     C     W0PMD         IFNE      'ADD'
      ** Change of position specified?
     C     WZNWRK        CASNE     #2NWRK        FBRQRL                         Netw Code
     C     WZTRCD        CASNE     #2TRCD        FBRQRL                         Tran Code
     C                   END
     C                   END
      ** Quit if reload requested.
     C     W0RSF         CABEQ     'Y'           DAEXIT
      *
     C   81              DO
      ** No data entered as yet.
     C                   MOVEL     'N'           WKIPIN            1
      ** Confirm/update is not defered.
     C                   MOVEL     'N'           W0DCF             1
      ** Process subfile records.
     C                   EXSR      DBPRSF
      ** If error, exit:
     C     *IN99         CABEQ     '1'           DAEXIT
      ** Defer confirm/update requested:
     C     W0DCF         CABEQ     'Y'           DAEXIT
      ** If data entered.
     C     WKIPIN        IFEQ      'Y'
      ** Update DBF from subfile.
     C                   EXSR      EAPRSF
      ** If error during update, exit:
     C     *IN99         CABEQ     '1'           DAEXIT
     C                   END                                                    WKIPIN
     C                   END                                                    OD 81
      ** Process function keys
      ** Switch between *ADD/*CHANGE modes.
     C   09              EXSR      FACHMD
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      ** Process modified subfile records.
      *================================================================
     C                   READC     SD009120S1                             92    *
     C     *IN92         DOWEQ     '0'
     C                   EXSR      DCPRSR
     C                   SETOFF                                       87        *
      ** Set screen conditioning indicators.
     C                   EXSR      GADSA1
     C                   UPDATE    SD009120S1
     C                   READC     SD009120S1                             92    *
     C                   END
      *
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      ** Process subfile record.
      *================================================================
      ** Setoff error indicators.
     C                   MOVEA     WKIND0        *IN(32)
     C                   SETOFF                                       98        No errors
     C                   SETOFF                                       84        NO SFLNXTCHG
     C     W0PMD         IFEQ      'ADD'
      ** Check for null record.
     C                   EXSR      DDNLRC
     C     W0NLR         IFEQ      'Y'
     C                   GOTO      DCEXIT
     C                   END
      ** If not null record, continue.
     C                   END
     C                   MOVEL     'Y'           WKIPIN                         Data entered
     C                   SETON                                        84        *SFLNXTCHG
      ** If delete request, bypass validation.
     C     #1SEL         IFEQ      'D'
     C                   GOTO      DCEXIT
     C                   END
      ** Validate subfile record.
     C                   EXSR      DEV1RC
      ** If SFLRCD invalid, note the fact.
     C   98
     CANN99              Z-ADD     wRRN          ##SFRC               99        Invalid SFLRCD
      *
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   DDNLRC        BEGSR
      *================================================================
      ** Check for null record.
      *================================================================
     C                   MOVEL     'N'           W0NLR             1
     C     #1NWRK        CABNE     *BLANK        DDEXIT
     C     #1TRCD        CABNE     *BLANK        DDEXIT
     C     #1DESC        CABNE     *BLANK        DDEXIT
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      ** Validate subfile record.
      *================================================================
      ** USER: Validate subfile record fields
      ** CASE:     PGM.*Program mode is *ADD
     C     W0PMD         IFEQ      @CN(04)                                      *IF
     C                   MOVEL     #1NWRK        WUTQKF                         Test ? in Key F
     C                   MOVEL     #1NWRK        WUIVKF                         If value in key
      ** CASE:     WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      @CN(05)                                      *IF
     C                   MOVEL     @CN(06)       W0RTN                          *Return code
      ** Setup message data for message.
     C                   MOVEL     #1NWRK        ZA0001                         Netw Code
      ** Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9833      *
      *
     C                   ELSE
      ** CASE:     WRK.If value in key field is Asterisk
     C     WUIVKF        IFEQ      @CN(07)                                      *IF
      ** Setup message data for message.
     C                   MOVEL     WUIVKF        ZA0002                         If value in key
     C                   MOVEL     #1NWRK        ZA0003                         Netw Code
      ** Send message 'Key Field Invalid Value'
     C                   MOVEL     'USR0849'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9833      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      ** Validate subfile record relations.
     C                   EXSR      DFV2RC
      ** Selection cannot be anything than 'D' or blanks.                                   MD024441
     C     #1SEL         IFNE      ' '                                          IF          MD024441
     C                   SETON                                        9832      *           MD024441
      ** Send message 'Action Code must be 'D''                                             MD024441
     C                   MOVEL     'USR4723'     ZAMSID                         Message id. MD024441
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message fileMD024441
     C                   EXSR      ZASNMS                                       Send messageMD024441
     C                   END                                                    FI          MD024441
      ** Netw Code required.
     C     #1NWRK        IFEQ      *BLANK                                       IF
     C                   SETON                                        9833      *
      *8 Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
      ** Transaction Code required.
     C     #1TRCD        IFEQ      *BLANK                                       IF
     C                   SETON                                        9835      *
      ** Send message '*Value required'
     C                   MOVEL     'USR6708'     ZAMSID                         Message id.
     C                   MOVEL     'SDUSRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
      *================================================================
     CSR   DEEXIT        ENDSR
      /EJECT
     CSR   DFV2RC        BEGSR
      *================================================================
      ** Validate subfile record relations.
      *================================================================
     CSR   DFEXIT        ENDSR
      /EJECT
     CSR   EAPRSF        BEGSR
      *================================================================
      ** Update DBF from subfile records.
      *================================================================
      ** Initialise subfile reload flag.
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'Y'           W0RSF
     C                   ELSE
     C                   MOVEL     'N'           W0RSF
     C                   END
      ** Process all modified subfile records.
     C                   READC     SD009120S1                             92    *
     C     *IN92         DOWEQ     '0'
      ** Process modified subfile record.
     C                   EXSR      EBPRSR
     C     W0RTN         IFNE      *BLANK
      ** Error: ROLLBACK any DBF changes.
     C                   ROLBK
     C                   ELSE
      ** Otherwise COMMIT any DBF changes.
     C                   COMMIT
     C                   END
     C                   MOVEL     *BLANK        #1SEL
      ** Set screen conditioning indicators.
     C                   EXSR      GADSA1
     C                   UPDATE    SD009120S1
     C                   READC     SD009120S1                             92    *
     C                   END
      ** If any errors, cancel reload.
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'N'           W0RSF             1
     C                   END
      *================================================================
     CSR   EAEXIT        ENDSR
      /EJECT
     CSR   EBPRSR        BEGSR
      *================================================================
      ** Process modified subfile record.
      *================================================================
      * Set off error indicators.
     C                   MOVEA     WKIND0        *IN(32)                        Clear errors
     C                   SETOFF                                       98        No errors
      *
     C     W0PMD         IFEQ      'ADD'
      ** Process add request.
     C     #1SEL         IFNE      'D'
     C                   EXSR      DDNLRC
     C     W0NLR         IFNE      'Y'
     C                   EXSR      ECADRQ
     C                   END
     C                   END
     C                   ELSE
     C     #1SEL         IFEQ      'D'
      ** Process delete request.
     C                   EXSR      EDDLRQ
     C                   ELSE
      ** Process change request.
     C                   EXSR      EECHRQ
     C                   END
     C                   END
      ** If error occurred on update, note the fact.
     C     *IN98         IFEQ      '1'
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     wRRN          ##SFRC               99        Error on update
     C                   END
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      ** Process add request.
      *================================================================
      ** USER: Create DBF record
      ** Create Network Transaction Codes
     C                   EXSR      SACRRC
     C     W0RTN         IFNE      *BLANK
      ** Write error detected.
     C                   MOVEA     WKIND1        *IN(32)                        Screen errors
     C                   SETON                                        98        Format Error
     C                   SETOFF                                       87        Enable entry
     C                   SETON                                        84        SFLNXTCHG
     C                   ELSE
      ** DBF Write successful.
     C                   SETON                                        87        Disable entry
     C                   SETOFF                                       84        No SFLNXTCHG
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      ** Process delete request.
      *================================================================
      ** USER: Delete DBF record
      ** Delete Network Transaction Codes
     C                   EXSR      SCDLRC
     C     W0RTN         IFNE      *BLANK
      ** Delete unsuccessful.
     C                   MOVEA     WKIND1        *IN(32)                        Screen errors
     C                   SETON                                        98        Format Error
     C                   SETOFF                                       87        Enable entry
     C                   SETON                                        84        SFLNXTCHG
      ** If record altered, reset subfile record.
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      * DBF Delete successful.
      * Blank out record and protect from entry.
     C                   EXSR      MAIZ#1
     C                   SETON                                        87        Disable entry
     C                   SETOFF                                       84        No SFLNXTCHG
     C                   MOVEL     'Y'           W0RSF             1            Reload subfile
     C                   END                                                    FI W0RTCD
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      ** Process update request.
      *================================================================
      ** USER: Change DBF record
      ** Change Network Transaction Codes
     C                   EXSR      SECHRC
     C     W0RTN         IFNE      *BLANK
      ** DBF Update error detected.
     C                   MOVEA     WKIND1        *IN(32)                        Screen errors
     C                   SETON                                        98        Format Error
     C                   SETOFF                                       87        Enable entry
     C                   SETON                                        84        SFLNXTCHG
      ** Reset subfile record if changed record.
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      ** DBF Update successful.
     C                   SETOFF                                       87        Enable entry
     C                   SETOFF                                       84        No SFLNXTCHG
     C                   END                                                    FI W0RTCD
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACHMD        BEGSR
      *================================================================
      ** Flip between *ADD and *CHANGE modes.
      *================================================================
     C     W0PMD         IFNE      'ADD'
     C                   MOVEL     'ADD'         W0PMD
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD
     C                   END
     C                   EXSR      FBRQRL
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   FBRQRL        BEGSR
      *================================================================
      ** Request subfile reload.
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        ENDSR
      /EJECT
     CSR   GADSA1        BEGSR
      *================================================================
      ** Set display attributes for Subfile record.
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect keys if change mode or updated record.
     C                   SETON                                        88        *
     C   89
     CANN87              SETOFF                                       88        *
     C                   MOVEL     *IN87         *IN79
     C     WUDELA        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSA2        BEGSR
      *================================================================
      ** Set display attributes for Subfile control.
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise subfile record.
      *================================================================
     C                   MOVEL     *BLANK        #1DBRC                         Previous values
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #1NWRK                         Netw Code
     C                   MOVEL     *BLANK        #1TRCD                         Trnx Code
     C                   MOVEL     *BLANK        #1DESC                         Desc Name
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      ** Move @NTCPAN fields to subfile.
      *================================================================
     C                   Z-ADD     NTLCD         #1LCD                          Last Change Dat
     C                   MOVEL     NTTYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     NTNWRK        #1NWRK                         Netw Code
     C                   MOVEL     NTTRCD        #1TRCD                         Trnx Code
     C                   MOVEL     NTDESC        #1DESC                         Desc Name
      ** Hold current record image for change detection.
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      ** Initialise subfile control.
      *================================================================
     C                   MOVEL     *BLANK        #2NWRK                         Netw Code
     C                   MOVEL     *BLANK        #2TRCD                         Trnx Code
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      ** Create Network Transaction Codes
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      ** Move all fields to @NTCPAM
     C                   MOVEL     #1NWRK        NTNWRK                         Netw Code
     C                   MOVEL     #1TRCD        NTTRCD                         trnx Code
     C                   MOVEL     #1DESC        NTDESC                         Desc Name
     C                   Z-ADD     WURDNB        NTLCD                          Last Change Dat
     C                   Z-ADD     WURDNB        NTORED                         Orig Change Dat
     C                   MOVEL     ##USR         NTIUSR                         Insert User Prf
     C                   MOVEL     @CN(08)       NTTYLC                         Type of Last Ch
      *
     C     KLCRSA        KLIST
     C                   KFLD                    NTNWRK
     C                   KFLD                    NTTRCD
      ** Check if Network Code exists.
     C     NTNWRK        CHAIN     @EDREJZ                            90
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR6706'     W0RTN
      ** Send message 'Network Transaction Codes EX'
     C                   MOVEL     'USR6706'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SAEXIT
     C                   ELSE
     C                   IF        %LEN(%TRIM(#1TRCD)) <> EDTRTP
     C                   MOVEL     'USR6709'     W0RTN
      ** Send message 'Network Transaction Codes length'
     C                   MOVEL     'USR6709'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SAEXIT
     C                   END
     C                   END
      ** Check for duplicate primary key.
     C     KLCRSA        SETLL     @NTCPAM                                90
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR6707'     W0RTN             7
      ** Send message 'Network Transaction Codes EX'
     C                   MOVEL     'USR6707'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SAEXIT
     C                   END
      *
      ** Check if Network ID Transaction Code already exists in SDNTTIPD
      *
     C                   WRITE     @NTCPAM                              91      *
      *
     C     *IN91         IFEQ      '1'
      ** Write error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      ** DBF Write successful.
      ** USER: Processing after DBF update
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
      ** Error detected ?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
      ** CASE:     PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      @CN(10)                                      *IF
      ** Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        98        *
      **
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SCDLRC        BEGSR
      *================================================================
      ** Delete Network Trnasaction Codes            *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      *
      ** Check if Network ID Transaction Code already exists in SDNTTIPD
      *
     C     1             SETLL     SDNTTID0
     C                   READ      SDNTTID0                               90
     C     *IN90         DOWEQ     '0'
     C                   IF        NINWRK = #1NWRK
     C                             AND NINTTI = #1TRCD
     C                   MOVEL     'USR6710'     W0RTN
      ** Send message 'Unable to delete record.'
     C                   MOVEL     'USR6710'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SCEXIT
     C                   ENDIF
     C                   READ      SDNTTID0                               90
     C                   ENDDO
      ** Move key fields to @NTCPAM
     C                   MOVEL     #1NWRK        NTNWRK
     C                   MOVEL     #1TRCD        NTTRCD
      *
     C     KLDLSC        KLIST
     C                   KFLD                    NTNWRK
     C                   KFLD                    NTTRCD
     C     KLDLSC        CHAIN     @NTCPAM                            9091      *
     C     *IN90         IFEQ      '1'
      ** Record already deleted.
     C                   MOVEL     'Y2U0009'     W0RTN
      ** Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      ** Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SCEXIT
     C                   END
      *
      ** Check for changed record.
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      ** Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
      ** Use SETLL to release record lock.
     C     KLDLSC        SETLL     @NTCPAM                            9091      *
     C                   GOTO      SCEXIT
     C                   END                                                    FI #1DBRC
      *................................................................
     C                   DELETE    @NTCPAM                              91      *
     C     *IN91         IFEQ      '1'
      ** Delete error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      ** DBF Delete successful.
      ** USER: Processing after DBF update
      ** WUDELR Data Structure - SD Deleted Records File  *
     C                   MOVEL     @1DBRC        WUDELR
      ** Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PARC
     C                   MOVEL     'SDNTCDPD'    PAFNME                         File name
     C                   EVAL      PALKEY = #1NWRK + #1TRCD
     C                   MOVEL     WUDR01        PADR01                         Deleted Data Re
     C                   MOVEL     WUDR02        PADR02                         Deleted Data Re
     C                   MOVEL     WUDR03        PADR03                         Deleted Data Re
     C                   MOVEL     WUDR04        PADR04                         Deleted Data Re
     C                   MOVEL     WUDR05        PADR05                         Deleted Data Re
     C                   MOVEL     WUDR06        PADR06                         Deleted Data Re
     C                   MOVEL     WUDR07        PADR07                         Deleted Data Re
     C                   MOVEL     WUDR08        PADR08                         Deleted Data Re
     C                   MOVEL     WUDR09        PADR09                         Deleted Data Re
     C                   MOVEL     WUDR00        PADR00                         Deleted Data Re
     C                   MOVEL     WUDR11        PADR11                         Deleted Data Re
     C                   MOVEL     WUDR12        PADR12                         Deleted Data Re
     C                   Z-ADD     WURDNB        PALCD                          Last Change Dat
     C                   MOVEL     'D'           PATYLC                         Type of Last Ch
      *
     C                   CALL      'SD0520X'                            90      Write Deleted R
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           RCD: SD Deleted
      *
     C     *IN90         IFEQ      '1'
      ** Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0520X'     W0CLPG
      ** Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      ** Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   Z-ADD     1             WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   MOVEL     @CN(11)       WUTYLC                         Type of Last Ch
      ** Error detected ?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
      ** CASE:     PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      @CN(10)                                      *IF
      ** Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SECHRC        BEGSR
      *================================================================
      ** Change Network Transaction Codes            *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      ** Move key fields to @NTCPAM
     C                   MOVEL     #1NWRK        NTNWRK
     C                   MOVEL     #1TRCD        NTTRCD
      *
     C     KLCHSE        KLIST
     C                   KFLD                    NTNWRK
     C                   KFLD                    NTTRCD
     C     KLCHSE        CHAIN     @NTCPAM                            9091      *
      *
     C     *IN90         IFEQ      '1'
      ** Record not found.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      ** Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SEEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      ** Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SEEXIT
     C                   END
      *
      ** Check for changed record.
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      ** Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
      ** Use SETLL to release record lock.
     C     KLCHSE        SETLL     @NTCPAM                            9091      *
     C                   GOTO      SEEXIT
     C                   END                                                    FI #1DBRC
      ** Move Non-key fields to @NTCPAM
     C                   MOVEL     #1NWRK        NTNWRK                         Netw Code
     C                   MOVEL     #1TRCD        NTTRCD                         Trnx Code
     C                   MOVEL     #1DESC        NTDESC                         Desc Code
     C                   Z-ADD     WURDNB        NTLCD                          Last Change Dat
     C                   MOVEL     @CN(12)       NTTYLC                         Type of Last Ch
     C                   MOVEL     ##USR         NTAUSR                         Amend User Prf
      *
     C                   UPDATE    @NTCPAM                              91      *
     C     *IN91         IFEQ      '1'
      ** Change error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      ** DBF Change successful.
      ** Update saved record image.
     C                   MOVEL     @1DBRC        #1DBRC
      ** USER: Processing after DBF update
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOAM                         No. of Amends
      ** Error detected ?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
      ** CASE:     PGM.*Return code is Old Table Error
     C     W0RTN         IFEQ      @CN(10)                                      *IF
      ** Send message 'Unable to update'
     C                   MOVEL     'USR0015'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue.
      *================================================================
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGM
     C                   END
      ** If no message file specified use default.
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      ** Clear all fields for default mechanism next time.
     C                   MOVEL     *BLANK        ZAPGM                          Program queue
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSID                         Message Id.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file.
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text.
      *================================================================
     C                   MOVEL     'Y'           W0HLP             1            Signal help req
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Member name.
     C                   PARM      *BLANK        YYHPFL           10            *DFT text file.
     C                   PARM      *BLANK        YYHPLB           10            Help text lib.
     C                   PARM                    W0RTN             7            Return Code.
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program: Normal.
      *================================================================
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      ** Exit program: Direct.
      *================================================================
      ** ROLLBACK any uncommitted DBF changes.
     C                   ROLBK                                          90
      *
      ** Terminate program.
     C                   SETON                                        LR
      *
      ** Exit program.
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      ** Initialisation.
      *================================================================
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
      ** Setup job date/time.
     C                   Z-ADD     UDATE         ##JDT                          Job date.
     C                   TIME                    ##JTM                          Job time.
     C                   TIME                    ##TME             6 0          Screen time.
      ** Define work field Deletion Allowed
     C                   MOVEL     *BLANK        WUDELA            1
      ** Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      ** Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      ** Define work field If value in key field
     C                   MOVEL     *BLANK        WUIVKF            1
      ** Obtain default message file.
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      ** Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      ** Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      ** Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      ** Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      ** Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      ** Define work field Deleted Data Record Pt1
     C                   MOVEL     *BLANK        WUDR01          250
      ** Define work field Deleted Data Record Pt2
     C                   MOVEL     *BLANK        WUDR02          250
      ** Define work field Deleted Data Record Pt3
     C                   MOVEL     *BLANK        WUDR03          250
      ** Define work field Deleted Data Record Pt4
     C                   MOVEL     *BLANK        WUDR04          250
      ** Define work field Deleted Data Record Pt5
     C                   MOVEL     *BLANK        WUDR05          250
      ** Define work field Deleted Data Record Pt6
     C                   MOVEL     *BLANK        WUDR06          250
      ** Define work field Deleted Data Record Pt7
     C                   MOVEL     *BLANK        WUDR07          250
      ** Define work field Deleted Data Record Pt8
     C                   MOVEL     *BLANK        WUDR08          250
      ** Define work field Deleted Data Record Pt9
     C                   MOVEL     *BLANK        WUDR09          250
      ** Define work field Deleted Data Record Pt10
     C                   MOVEL     *BLANK        WUDR00          250
      ** Define work field Deleted Data Record Pt11
     C                   MOVEL     *BLANK        WUDR11          250
      ** Define work field Deleted Data Record Pt12
     C                   MOVEL     *BLANK        WUDR12          250
      ** Define work field Type of Last Change
     C                   MOVEL     *BLANK        WUTYLC            1
      ** Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      ** Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      ** Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      ** Open files.
      ** Begin commit control.
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
     C                   OPEN      SDNTCDL1
     C                   OPEN      SDNWRKL1
     C                   OPEN      SDNTTIPD
      *
     C                   Z-ADD     15            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
     C                   Z-ADD     *ZERO         wRRNMX                         MAX RECNO
      ** If member empty, set to *ADD mode, else to *CHANGE mode.
     C     @1NROP        IFEQ      *ZERO
     C                   MOVEL     'ADD'         W0PMD             3            Add mode
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD                          Change mode
     C                   END
      ** USER: Initialise program
      ** Last Amend Box SD009120 - Network Transaction Codes
      ** Standard RPG Creation PAR - Standard Functions
      ** Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT                         RUN DATE       S0122
     C                   MOVE      MRDT          WUMRDT                                        S0122
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.     S0122
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT  S0122
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG   S0122
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND  S0122
      ** Copyright Statement - Standard Functions  * copyright
      ** Initialise subfile control.
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2013
**CTDATA @CN
N
CHG
Y
ADD
?
?INVAL
*
I
SDNTCDPD
*ERROR*
D
A
