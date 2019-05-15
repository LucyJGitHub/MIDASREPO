     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas UT Stack Generation Utility by Error Codes')     *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities module                                     *
      *                                                               *
      *  UT00100402 - Midas UT Stack Generation Utlity by Error Codes *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CBF011  *CREATE    Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     ** Error Messages/Message Files Usage List by Distinct Message ID
     FV_UTERMF0 IF   E           K DISK    RENAME(V_UTERMF0:UTERMUF0)
 
     ** Error Codes/Message Files List by Message ID
     FV_UTERCF0 IF   E           K DISK    RENAME(V_UTERCF0:UTERCDF0)
 
     ** Error Codes/Message Files List
     FUTERCDL0  IF   E           K DISK    PREFIX(A)
 
     ** Error Messages/Message Files Usage List by Calling Program
     FUTERMUL1  IF   E           K DISK    PREFIX(B)
 
     ** Program Reference File by Program Name
     FUTPREFL1  IF   E           K DISK    RENAME(QWHDRPPR:UTPREFF)
 
     ** Stack Generation Engine Report File
     FUTSG01L0  IF   E             DISK    RENAME(UTSG01F:UTSG01)
     F                                     PREFIX(ST_)
 
     ** Stack Generation Engine Report File by Main Program
     FUTSG01L1  IF   E           K DISK    RENAME(UTSG01F:UTSG03)
     F                                     PREFIX(MP_)
 
     ** Stack Generation Engine Report File
     FUTSG01L2  IF   E             DISK    RENAME(UTSG01F:UTSG02)
     F                                     PREFIX(CD_)
 
     ** Stack Generation Engine Report File by Reference Program
     FUTSG01L3  IF   E           K DISK    RENAME(UTSG01F:UTSG04)
     F                                     PREFIX(RP_)
 
     ** Error Messages Usage Stack Generation Exceptions File
     FUTEREXL0  IF   E           K DISK
 
      ** Error Messages/Message Files List Report
     FUT1004P2  O    E             PRINTER INFDS(SPOOL1)
     F                                     INFSR(*PSSR)
     F                                     OFLIND(*IN81)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     DException        S             78    DIM(1) CTDATA PERRCD(1)
      ** Exception Message Array
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details Accessed via Access Program
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
      ** File Information Data Structure for UTEERSPRTF
     D SPOOL1          DS
     D SFILE                  83     92
     D SFNUM1                123    124B 0
     D OFLLN1                188    189B 0
     D PRTLN1                367    368B 0
 
      ** Message ID Description Data Structure
     D WMDescDS        DS           140
     D  WMDesc1                1     70
     D  WMDesc2               71    140
 
      ** Blank Data Structure
     D WBlankDS        DS            25
     D  WBlank1                1     10
     D  WBlank2               11     25
 
      ** Program Name & Description Data Structure
     D WPNamDescDS     DS            62
     D  WPName                 1     10
     D  WPDash                11     12
     D  WPDesc                13     62
 
      ** Level Indention Data Structure
     D WIndentDS       DS            40
     D  WIndent1               1      2
     D  WIndent2               1      4
     D  WIndent3               1      6
     D  WIndent4               1      8
     D  WIndent5               1     10
     D  WIndent6               1     12
     D  WIndent7               1     14
     D  WIndent8               1     16
     D  WIndent9               1     18
     D  WIndent10              1     20
     D  WIndent11              1     22
     D  WIndent12              1     24
     D  WIndent13              1     26
     D  WIndent14              1     28
     D  WIndent15              1     30
     D  WIndent16              1     32
     D  WIndent17              1     34
     D  WIndent18              1     36
     D  WIndent19              1     38
     D  WIndent20              1     40
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      ** Access Object Parameters
     D PRTCD           S              7
     D POPTN           S              7
 
      ** Other fields
     D WCount          S              5S 0 INZ(0)
     D WNoRec          S              5S 0 INZ(0)
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D WRecNo          S             10S 0 INZ(0)
     D WRead           S             10S 0 INZ(0)
     D WLevel          S              5S 0 INZ(0)
     D WLevel2         S              5S 0 INZ(0)
     D WLvlCnt         S              5S 0 INZ(0)
     D WLvlCnt2        S              5S 0 INZ(0)
     D WDCount         S              5S 0 INZ(0)
     D WRRN            S              1S 0 INZ(0)
     D WPMain          S             10A
     D WErcPgm         S             10A
 
      ** Batch Monitor Update Varibles
     D@LEN             S             15P 5
     D@CMD             S             50A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   WRITE     HEADER
 
     C                   READ      UTERMUF0                               01
 
     C                   DOW       *IN01 = *OFF
 
     C                   EXSR      ChkException
 
     C                   EXSR      WriteErr
     C                   EVAL      WMDesc2 = *Blanks
     C                   EVAL      *IN20 = *OFF
 
     C                   EXSR      SearchPgm
 
     C                   EVAL      WNoRec = WNoRec + 1
     C                   READ      UTERMUF0                               01
     C                   ENDDO
 
     C                   EXSR      WriteTrailer
 
     C                   EVAL      @CMD = 'CHGDTAARA DTAARA(UTSGSTAT (2 1 +
     C                                     )) VALUE(Y)'
     C                   EVAL      @LEN = 50
     C                   CALL      'QCMDEXC'
     C                   PARM                    @CMD
     C                   PARM                    @LEN
 
     C                   SETON                                            LR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * ChkException - Check Exception                                *
      *****************************************************************
     C     ChkException  BEGSR
 
     C     ERERID        CHAIN     UTEREXL0                           02
 
     C                   IF        *IN02 = *OFF
     C                   EVAL      RERRD1 = ERERID + ' - ' +
     C                                      Exception(1)
     C                   ELSE
 
     C     ERERID        CHAIN     UTERCDL0                           19
     C                   EVAL      WMDescDS = ADMMSGT
     C                   EVAL      RERRD1 = ADMMIDR + ' - ' +
     C                             WMDesc1 + WBlank2 + ADMFILE
 
     C                   IF        WMDesc2 <> *Blanks
     C                   EVAL      *IN20 = *ON
     C                   EVAL      RERRD2 = WBlank1 + WMDesc2
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * WriteErr - Write Error ID and Error ID Description            *
      *****************************************************************
     C     WriteErr      BEGSR
 
     C                   EVAL      RqdLn1 = 2
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADER
     C                   ENDIF
 
     C                   WRITE     ERRDET
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SearchPgm - Search Calling Program                            *
      *****************************************************************
     C     SearchPgm     BEGSR
 
     C                   EVAL      WErcPgm = *BLANKS
 
     C     ERERID        SETLL     UTERMUL1
     C     ERERID        READE     UTERMUL1                               03
 
     C                   DOW       *IN03 = *OFF
 
     C                   IF        WErcPgm <> BERCPGM
 
     C                   EVAL      WErcPgm = BERCPGM
     C                   EXSR      GetStack
 
     C                   ENDIF
 
     C     ERERID        READE     UTERMUL1                               03
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GetStack - Get Call Stack                                     *
      *****************************************************************
     C     GetStack      BEGSR
 
     C     BERCPGM       CHAIN     UTSG01L1                           07
 
     C                   IF        *IN07 = *OFF
     C                   EVAL      WPName = BERCPGM
     C                   EXSR      GetDesc
     C                   EVAL      RSTACK = WIndent1 + WPNamDescDS
     C                   EVAL      *IN21 = *ON
     C                   EXSR      WriteStack
     C                   EVAL      *IN21 = *OFF
 
     C                   ELSE
 
     C     BERCPGM       SETLL     UTSG01L3
     C     BERCPGM       READE     UTSG01L3                               03
 
     C                   DOW       *IN03 = *OFF
 
     C                   EXSR      CreateStack
 
     C     BERCPGM       READE     UTSG01L3                               03
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GetDesc - Get Program Description                             *
      *****************************************************************
     C     GetDesc       BEGSR
 
     C     WPName        CHAIN     UTPREFF                            04
     C                   IF        *IN04 = *OFF
     C                   EVAL      WPDesc = WHTEXT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CreateStack - Create Call Stack                               *
      *****************************************************************
     C     CreateStack   BEGSR
 
     C                   EVAL      WLevel = 0
     C                   EVAL      WLvlCnt = 0
     C                   EVAL      WDCount = 0
     C                   EVAL      WRead = RP_SGSEQN + 1
     C                   EVAL      *IN22 = *OFF
 
     C     WRead         SETLL     UTSG01L2
     C                   READP     UTSG01L2                               05
 
     C                   EVAL      WLevel = CD_SGRLVL
     C                   EVAL      WLvlCnt = CD_SGRLVL - 1
 
     C                   DOW       WLevel > 1
 
     C                   IF        CD_SGDTAG = 'Y'
     C                   EVAL      WDCount = WDCount + 1
     C                   ENDIF
 
     C                   READP     UTSG01L2                               05
     C                   EVAL      WLevel = WLevel - 1
 
     C                   ENDDO
 
     C                   IF        WLvlCnt = WDCount
     C                   EVAL      *IN22 = *ON
     C                   ENDIF
 
     C                   EVAL      WLevel2 = 0
     C                   EVAL      WLvlCnt2 = 0
 
     C                   IF        *IN22 = *OFF
 
     C     WRead         SETLL     UTSG01L0
     C                   READP     UTSG01L0                               06
 
     C                   EVAL      WLevel2 = ST_SGRLVL
 
     C                   DOW       WLevel2 > 0
 
     C                   EVAL      WLvlCnt2 = WLvlCnt2 + 1
 
     C                   IF        WLevel2 = 2
     C                   EVAL      WPMain = ST_SGMPRG
     C                   ENDIF
 
     C                   IF        WLevel2 = 1
     C                   EVAL      WPName = WPMain
     C                   EVAL      *IN21 = *ON
     C                   ELSE
     C                   EVAL      WPName = ST_SGRPRG
     C                   ENDIF
 
     C                   EXSR      GetDesc
 
     C                   SELECT
     C                   WHEN      WLvlCnt2 = 1
     C                   EVAL      RSTACK = WIndent1 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 2
     C                   EVAL      RSTACK = WIndent2 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 3
     C                   EVAL      RSTACK = WIndent3 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 4
     C                   EVAL      RSTACK = WIndent4 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 5
     C                   EVAL      RSTACK = WIndent5 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 6
     C                   EVAL      RSTACK = WIndent6 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 7
     C                   EVAL      RSTACK = WIndent7 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 8
     C                   EVAL      RSTACK = WIndent8 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 9
     C                   EVAL      RSTACK = WIndent9 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 10
     C                   EVAL      RSTACK = WIndent10 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 11
     C                   EVAL      RSTACK = WIndent11 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 12
     C                   EVAL      RSTACK = WIndent12 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 13
     C                   EVAL      RSTACK = WIndent13 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 14
     C                   EVAL      RSTACK = WIndent14 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 15
     C                   EVAL      RSTACK = WIndent15 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 16
     C                   EVAL      RSTACK = WIndent16 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 17
     C                   EVAL      RSTACK = WIndent17 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 18
     C                   EVAL      RSTACK = WIndent18 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 19
     C                   EVAL      RSTACK = WIndent19 + WPNamDescDS
     C                   WHEN      WLvlCnt2 = 20
     C                   EVAL      RSTACK = WIndent20 + WPNamDescDS
     C                   ENDSL
 
     C                   EXSR      WriteStack
 
     C                   EVAL      *IN21 = *OFF
 
     C                   READP     UTSG01L0                               06
     C                   EVAL      WLevel2 = WLevel2 - 1
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * WriteStack - Write Call Stack                                 *
      *****************************************************************
     C     WriteStack    BEGSR
 
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADER
     C                   ENDIF
 
     C                   WRITE     CSTACK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * WriteTrailer - Write End of Report                            *
      *****************************************************************
     C     WriteTrailer  BEGSR
 
     C                   EVAL      RqdLn1 = 3
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADER
     C                   ENDIF
 
     C                   WRITE     TRAILER
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG'        PRTCD
     C                   PARM      '*FIRST'      POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-ADD     0             RQDLN1
     C                   Z-ADD     0             DIFLN1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   EVAL      @CMD = 'CHGDTAARA DTAARA(UTSGSTAT (2 1 +
     C                                     )) VALUE(Y)'
     C                   EVAL      @LEN = 50
     C                   CALL      'QCMDEXC'
     C                   PARM                    @CMD
     C                   PARM                    @LEN
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
** Exception
*Error code exists in multiple message files*
