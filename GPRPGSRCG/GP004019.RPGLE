     H DEBUG ALWNULL(*USRCTL)
     H COPYRIGHT('(c) Finastra International Limited 2017')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Midas Users Housekeeping')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP004019 - Midas Users Housekeeping                          *
      *                                                               *
      *  (c) Finastra International Limited 2017                      *
      *                                                               *
      *  Function:  This program will delete all records from         *
      *             MUSERDD, MBRBSDD, MBROSDD and MCMPSDD files       *
      *             reaching retention period with RECI = 'R'         *
      *                                                               *
      *  Called by: GOC004019 - Midas GO Midas Users Housekeeping     *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CBF023  *CREATE    Date 04Jan17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF023 - Soft Delete Feature on Security Related Modules     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *   60    - Read until EOF of MUSERDD                           *
      *   61    - Read until EOF of MBROSDD                           *
      *   62    - Read until EOF of MBRBSDD                           *
      *   63    - Read until EOF of MCMPSDD                           *
      *                                                               *
      *****************************************************************
     FMUSER     UF   E           K DISK    INFSR(*PSSR) COMMIT USROPN
      ** Midas SF Midas users by user
 
     FMBROS     UF   E           K DISK    INFSR(*PSSR) COMMIT USROPN
      ** Midas SF Valid originating branches by user
 
     FMCMPS     UF   E           K DISK    INFSR(*PSSR) COMMIT USROPN
      ** Midas SF Valid companies by user
 
     FMBRBS     UF   E           K DISK    INFSR(*PSSR) COMMIT USROPN
      ** Midas SF Valid booking branches by user
 
     FGP004019P1O    E             PRINTER INFSR(*PSSR) INFDS(SPOOL1) USROPN
      ** GP Midas User Housekeeping Report
 
     FGP004019AUO    E             PRINTER INFSR(*PSSR) INFDS(SPOOLU) USROPN
      ** GP Midas User Housekeeping Audit
 
 
      *****************************************************************
      ** Data Structures and Variables                               **
      *****************************************************************
 
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
 
     D WRetPrdN        S              6  0
     D WUsrRetPrd      S              6  0
     D WRun            S              1A
 
     D MaxRptLine      S              3  0
     D CurRptLine      S              3  0
     D FirstPage       S              1A
     D RecordCount     S              5  0
 
     D ReptSeq         S              5A
     D Entity          S              3A
     D ZSNUMU          S              6  0
     D ZSERRU          S              1
     D ZSNUM           S              6  0
     D ZSERR           S              1
 
     D POp01           S             20
     D PVl01           S            200
     D POp02           S             20
     D PVl02           S            200
     D POp03           S             20
     D PVl03           S            200
     D POp04           S             20
     D PVl04           S            200
     D POp05           S             20
     D PVl05           S            200
     D POp06           S             20
     D PVl06           S            200
     D POp07           S             20
     D PVl07           S            200
     D POp08           S             20
     D PVl08           S            200
     D POp09           S             20
     D PVl09           S            200
     D POp10           S             20
     D PVl10           S            200
 
     D CmdLen          S             15P 5 INZ(50)
     D CMDOV1          S             50    DIM(1) CTDATA PERRCD(1)
     D CMDOV2          S             50    DIM(1) CTDATA PERRCD(1)
 
     D CBF023          S              1A
     D RetPeriod       C                   CONST('MidasUsersRetention')
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D SPOOL1          DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D  SFPLE                152    153B 0
     D  SFOVR                188    189B 0
     D  SFCUR                367    368B 0
 
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D  SFPLEU               152    153B 0
     D  SFOVRU               188    189B 0
     D  SFCURU               367    368B 0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY GPCPYSRCG,PSDS
      ** Program Status Data Structure
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EXSR      SrMUSERDel
     C                   EXSR      SrMBROSDel
     C                   EXSR      SrMBRBSDel
     C                   EXSR      SrMCMPSDel
 
      ** Output report trailer
 
     C                   IF        RecordCount <> 0
 
      ** Check for overflow line, output heading if required
 
     C                   Z-ADD     SFOVR         MaxRptLine
     C                   Z-ADD     SFCUR         CurRptLine
     C                   IF        ((MaxRptLine-CurRptLine) < 4) OR
     C                             FirstPage = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      FirstPage = 'N'
     C                   ENDIF
 
     C                   WRITE     TRAILP1
     C                   ENDIF
 
      ** Generate Audit Report
 
     C                   EXSR      SRAudit
 
     C                   CLOSE     MUSER
     C                   CLOSE     MBRBS
     C                   CLOSE     MBROS
     C                   CLOSE     MCMPS
 
      ** Initiate BankFusion Web Service Call to BatchProcessPurgingWS
 
     C                   CALL      'BF004019'
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZR - Program initialisation subroutine.                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Retrieve run date from SDBANKPD
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   EVAL      DBKey = POptn
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Call AOSVALR0 to get the retention period
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      RetPeriod     POp01
     C                   PARM      *BLANKS       PVl01
     C                   PARM      *BLANKS       POp02
     C                   PARM      *BLANKS       PVl02
     C                   PARM      *BLANKS       POp03
     C                   PARM      *BLANKS       PVl03
     C                   PARM      *BLANKS       POp04
     C                   PARM      *BLANKS       PVl04
     C                   PARM      *BLANKS       POp05
     C                   PARM      *BLANKS       PVl05
     C                   PARM      *BLANKS       POp06
     C                   PARM      *BLANKS       PVl06
     C                   PARM      *BLANKS       POp07
     C                   PARM      *BLANKS       PVl07
     C                   PARM      *BLANKS       POp08
     C                   PARM      *BLANKS       PVl08
     C                   PARM      *BLANKS       POp09
     C                   PARM      *BLANKS       PVl09
     C                   PARM      *BLANKS       POp10
     C                   PARM      *BLANKS       PVl10
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBase = 2
     C                   EVAL      DBKey = POp01
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WRetPrdN = %INT(PVl01)
     C                   EVAL      WUsrRetPrd = BJRDNB - WRetPrdN
     C                   ENDIF
 
      ** Check if CBF023 is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CBF023'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C                             AND PRtCd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   EVAL      DBKey = PSard
     C                   EVAL      DBase = 3
     C                   EVAL      DBPgm = 'GP004019'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      CBF023 = 'N'
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CBF023 = 'Y'
     C                   ENDIF
 
      ** Initialise report work fields and counter
 
     C                   EVAL      RecordCount = 0
     C                   EVAL      FirstPage   = 'Y'
 
     C                   OPEN      MUSER
     C                   OPEN      MBRBS
     C                   OPEN      MBROS
     C                   OPEN      MCMPS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMUSERDel - Purge soft deleted records in MUSERDD            *
      *                                                               *
      *****************************************************************
     C     SrMUSERDel    BEGSR
 
     C     *LOVAL        SETLL     MUSER
     C                   READ      MUSER                                  60
 
     C     *IN60         DOWEQ     '0'
 
     C                   IF        (BJRDNB - LCD) > WRetPrdN
     C                             AND RECI = 'R'
     C                   DELETE    MUSERDDF
 
     C                   EVAL      RecordCount = RecordCount + 1
     C                   EXSR      SrPrint
 
     C                   ENDIF
 
     C                   READ      MUSER                                  60
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMBROSDel - Purge soft deleted records in MBROSDD            *
      *                                                               *
      *****************************************************************
     C     SrMBROSDel    BEGSR
 
     C     *LOVAL        SETLL     MBROS
     C                   READ      MBROS                                  61
 
     C     *IN61         DOWEQ     '0'
 
     C                   IF        (BJRDNB - LCD) > WRetPrdN
     C                             AND RECI = 'R'
     C                   DELETE    MBROSDDF
     C                   ENDIF
 
     C                   READ      MBROS                                  61
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMBRBSDel - Purge soft deleted records in MBRBSDD            *
      *                                                               *
      *****************************************************************
     C     SrMBRBSDel    BEGSR
 
     C     *LOVAL        SETLL     MBRBS
     C                   READ      MBRBS                                  62
 
     C     *IN62         DOWEQ     '0'
 
     C                   IF        (BJRDNB - LCD) > WRetPrdN
     C                             AND RECI = 'R'
     C                   DELETE    MBRBSDDF
     C                   ENDIF
 
     C                   READ      MBRBS                                  62
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrMCMPSDel - Purge soft deleted records in MCMPSDD            *
      *                                                               *
      *****************************************************************
     C     SrMCMPSDel    BEGSR
 
     C     *LOVAL        SETLL     MCMPS
     C                   READ      MCMPS                                  63
 
     C     *IN63         DOWEQ     '0'
 
     C                   IF        (BJRDNB - LCD) > WRetPrdN
     C                             AND RECI = 'R'
     C                   DELETE    MCMPSDDF
     C                   ENDIF
 
     C                   READ      MCMPS                                  63
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit - Generate Audit Report                               *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
      ** Open & enroll report file
 
     C                   IF        NOT %OPEN(GP004019AU)
     C                   OPEN      GP004019AU
 
     C                   Z-ADD     SFNUMU        ZSNUMU
 
      ** Override MUSER
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMDOV1
     C                   PARM                    CmdLen
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       ReptSeq
     C                   PARM      *BLANKS       Entity
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM                    ZSERRU
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMDOV2
     C                   PARM                    CmdLen
 
     C                   IF        ZSERRU = 'Y'
     C                   EVAL      DBFile =  'ZSFILE'
     C                   EVAL      DBKey  =  'GP004019AU'
     C                   EVAL      DBPgm  =  'GP004019'
     C                   EVAL      DBase  =  4
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
 
     C                   ENDIF
 
      ** Output audit heading
 
     C                   WRITE     HEADAU
 
      ** Output audit detail
 
     C                   IF        *INU7 = *OFF AND
     C                             *INU8 = *OFF
     C                   IF        RecordCount <> 0
     C                   Z-ADD     RecordCount   RCOUNT
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ELSE
     C                   WRITE     DBERROR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrOpenP1 - Open and Enroll report file                        *
      *                                                               *
      *****************************************************************
 
     C     SrOpenP1      BEGSR
 
      ** Open & enroll report file
 
     C                   IF        NOT %OPEN(GP004019P1)
     C                   OPEN      GP004019P1
     C
     C                   Z-ADD     SFNUM         ZSNUM
 
      ** Override MUSER
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMDOV1
     C                   PARM                    CmdLen
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       ReptSeq
     C                   PARM      *BLANKS       Entity
     C                   PARM                    SFILE
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR
 
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMDOV2
     C                   PARM                    CmdLen
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      DBFILE =  'ZSFILE'
     C                   EVAL      DBKEY  =  'GP004019P1'
     C                   EVAL      DBPGM  =  'GP004019'
     C                   EVAL      DBASE  =  5
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrint - Print Details                                       *
      *                                                               *
      *****************************************************************
 
     C     SrPrint       BEGSR
 
      ** Open & enroll report file
 
     C                   EXSR      SrOpenP1
 
      ** Set up report fields
 
     C                   EVAL      RUSRP      = USRP
     C                   EVAL      RUSER1     = USER1
 
      ** Check for overflow line, output heading if required
 
     C                   Z-ADD     SFOVR         MaxRptLine
     C                   Z-ADD     SFCUR         CurRptLine
     C                   IF        ((MaxRptLine-CurRptLine) < 3) OR
     C                             FirstPage = 'Y'
     C                   WRITE     HEADP1
     C                   EVAL      FirstPage = 'N'
     C                   ENDIF
 
      ** Output detail line
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
 
     C                   EXSR      SRAudit
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
** CMDOV1
OVRDBF FILE(MUSER) TOFILE(MUSER) SHARE(*NO)
** CMDOV2
DLTOVR FILE(MUSER)
