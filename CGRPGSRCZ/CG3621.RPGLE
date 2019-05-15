     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Schema & elmnt names refr conversion list')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3621 - Schema and Element names maintenance                *
      *           References Conversion List                          *
      *                                                               *
      *  Function:  This module will list in an alphabetical order    *
      *             all the References attached to the Group Set      *
      *             Definition being amended or displayed.            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CCG015  *CREATE    Date 09Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Subfile Next change                             *
      *    02         Display Attributes of Selection field #0SELE    *
      *    03         Subfile Clear                                   *
      *    04         Subfile Display                                 *
      *    05         Subfile End                                     *
      *    06         Rollup                                          *
      *    07         Message Subfile                                 *
      *    08         End of file/No record found (CG3621S0)          *
      *    09         End of file/No record found (CGRDECL0)          *
      *    10         End of file/No record found (CG3621S0)          *
      *    11         End of file/No record found (CGPTYPL2)          *
      *    12         Display Attributes of 'Position to field' #0RFFE*
      *                                                               *
      *    90-99      Used by Standard Subroutines                    *
      *                                                               *
      *    U7+U8      Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRIZSF - Initialise and Load Subfile Page                    *
      *  SRLOAD - Load One Page of Subfile                            *
      *  SRSNMS - Send Message to Program's Message Queue             *
      *  SRDSPS - Display Screen Processing                           *
      *  SREXPR - Exit and Previous Screen Processing                 *
      *  SRFRSH - Refresh Subfile Screen                              *
      *  SRPROC - Selection Processing                                *
      *  SRVALS - Validate Selection Field on Subfile                 *
      *  SRREFPR- Process Reference Selected                          *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *  *INSZR - Initialisation routine                              *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FCGPTYPL2  IF   E           K DISK    INFSR(*PSSR)
      ** Midas CG Print Type/Sub-Type
 
     FCGRDECL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas UDC Name Conversion
 
     FCG3621DF  CF   E             WORKSTN
     F                                     SFILE(CG3621S0:#0SFLR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data Structure for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PReturnCode     S              7
     D PGroupSetDef    S              6
     D PDescription    S             30
     D PSelOption      S              1
     D PReference      S             23
     D PReferDesc      S             30
     D PSchemaNam      S             30
     D PFunctionKey    S              2
     D PMsgID          S              7
     D PMsgFile        S             10
     D PMsgData        S            244
     D PText1          S            132
     D PText2          S            512
     D PMsgFLib        S             10
     D PMsgDt          S            256
     D PMsgr           S              5
     D PPrgm           S             10
     D PMsgQ           S             10
     D PMsgType        S              7
     D PRtnCode        S              7
     D POption         S              7
     D KGrpSet         S              6
     D KPType          S             10
     D KPSTyp          S             10
     D KType           S              4
     D KArgt           S            111
     D WRUN            S              1
     D WLRecordNo      S              4  0
     D WResetSf        S              1
     D WValid          S              1
     D WColon          S              2  0
     D WPType          S             10
     D WPSTyp          S             10
     D WSavRF          S             23
     D WRCountr        S              5  0
     D WSubfPag        S              5  0
     D WNoData         S              1
     D WCall35         S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   DOW       *INKC = *OFF AND *INKL = *OFF
     C                             AND PFunctionKey<>'03' AND *IN10=*OFF
 
      ** Initialise and load subfile page.
 
     C                   EXSR      SRIZSF
 
      ** Initialise reset field.
 
     C                   EVAL      WResetSF='N'
     C                   DOW       WResetSF='N' AND *INKC=*OFF
     C                             AND *INKL=*OFF AND PFunctionKey<>'03'
     C                             AND *IN10=*OFF
 
      ** Display Screen.
 
     C                   EXSR      SRDSPS
 
      ** Perform detailed processing.
 
     C                   IF        *INKC = *ON OR *INKL = *ON
 
      ** If F3 or F12 was pressed, exit or go to the previous screen.
 
     C                   EXSR      SREXPR
 
     C                   ELSE
 
      ** If F5 was pressed, refresh the subfile screen.
 
     C     *INKE         CASEQ     *ON           SRFRSH
 
      ** If Rollup/Rolldown was pressed, load one page of subfile.
 
     C     *IN06         CASEQ     *ON           SRLOAD
 
      ** If no function key was pressed, process input on the screen.
 
     C                   CAS                     SRPROC
 
     C                   ENDCS
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDDO
 
     C                   EVAL      *INLR=*ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRIZSF - Initialise and Load Subfile Page                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRLOAD                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRIZSF        BEGSR
 
      ** Clear subfile
 
     C                   EVAL      *IN03 = '1'
     C                   WRITE     CG3621C0
     C                   EVAL      *IN03 = '0'
 
      ** Reset number of records in subfile.
 
     C                   EVAL      WLRecordNo = 0
 
     C                   EVAL      #0GRPS=PGroupSetDef
     C                   EVAL      #0DSCG=PDescription
 
      ** Set the pointer of CGPTYPL2 equal to the group set definition
      ** (partial key) or to 'Position on: Reference' definition.
 
     C                   IF        #0RFFE = *BLANKS
 
     C     #0GRPS        SETLL     CGPTYPL2
 
     C                   ELSE
 
     C                   EVAL      KGrpSet=#0GRPS
     C                   EVAL      KPType=WPType
     C                   EVAL      KPSTyp=WPSTyp
 
     C     KEYCgptyp     SETLL     CGPTYPL2
 
     C                   ENDIF
 
      ** Save previous selection criteria.
 
     C                   EVAL      WSavRF=#0RFFE
 
      ** Load one page of subfile.
 
     C                   EXSR      SRLOAD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLOAD - Initialise and Load Subfile Page                     *
      *                                                               *
      * Called by: Main Processing, SRIZSF                            *
      *                                                               *
      * Calls: ZA0250,SRSNMS                                          *
      *                                                               *
      *****************************************************************
 
     C     SRLOAD        BEGSR
 
      ** Set subfile record load counter to 1.
 
     C                   EVAL      WRCountr=1
 
     C                   EVAL      #0SFLR=WLRecordNo
     C                   EVAL      #0SELE=*BLANKS
     C                   EVAL      *IN05=*OFF
     C                   EVAL      *IN12=*OFF
     C                   EVAL      *IN02=*OFF
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
      ** Read CGPTYPL2.
 
     C     #0GRPS        READE     CGPTYPL2                               11
 
      ** No data to display
 
     C                   IF        *IN11=*ON
 
     C                   IF        WSavRF=*BLANKS
     C                   EVAL      *IN12=*ON
     C                   ENDIF
 
     C                   EVAL      WValid='N'
     C                   EVAL      PMsgID='CGD2580'
     C                   EXSR      SRSNMS
     C                   EVAL      *IN04=*OFF
 
     C                   ELSE
 
      ** Seton SFLDSP.
 
     C                   EVAL      *IN04=*ON
 
     C                   ENDIF
 
      ** Load records until end of file and while subfile page is not
      ** full.
 
     C                   DOW       *IN11=*OFF AND WRCountr <= WSubfPag
 
      ** Load fields here.
     C                   EVAL      #0ARGT = %TRIMR(ITPTYP) + ':'
     C                               + ITPSTP
     C                   EVAL      #0DSCR=ITDESC
 
     C                   EVAL      KType='REFR'
     C                   EVAL      KArgt=#0ARGT
 
     C     KEYCgrdec     CHAIN     CGRDECL0                           09
 
      ** If record found and 'New Field' is not blank,
 
     C                   IF        *IN09 = *OFF AND CGNWFD<>*BLANKS
 
     C                   EVAL      #0NWFD=CGNWFD
 
     C                   ELSE
 
     C                   EVAL      #0NWFD=PText1
 
     C                   ENDIF
 
      ** Write records to SFL
 
     C                   ADD       1             #0SFLR
     C                   ADD       1             WRCountr
 
     C                   WRITE     CG3621S0
 
     C     #0GRPS        READE     CGPTYPL2                               11
 
     C                   ENDDO
 
      ** Seton SFLEND indicator if end of file.
 
     C                   IF        *IN11=*ON
     C                   EVAL      *IN05=*ON
     C                   ELSE
     C                   READP     CGPTYPL2                             11
     C                   ENDIF
 
      ** No records on subfile
 
     C                   IF        #0SFLR=0
     C                   EVAL      WNoData='Y'
     C                   ELSE
     C                   EVAL      WNoData='N'
     C                   ENDIF
 
      ** Save last relative record number to workfield.
 
     C                   EVAL      WLRecordNo=#0SFLR
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSNMS - Send Message to Program's Message Queue              *
      *                                                               *
      * Called by: SRLOAD, SRVALS                                     *
      *                                                               *
      * Calls: AOCREPT                                                *
      *                                                               *
      *****************************************************************
 
     C     SRSNMS        BEGSR
 
     C                   CALL      'AOCREPT'
     C                   PARM                    PMsgID
     C                   PARM                    PMsgFile
     C                   PARM      *BLANKS       PMsgFLib
     C                   PARM      *BLANKS       PMsgDt
     C                   PARM      *BLANKS       PMsgr
     C                   PARM      *BLANKS       PPrgm
     C                   PARM      *BLANKS       PMsgQ
     C                   PARM      *BLANKS       PMsgType
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDSPS - Display Screen Processing                            *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRDSPS        BEGSR
 
     C                   WRITE     CG3621F1
     C                   WRITE     CG3621C1
     C                   WRITE     CG3621F0
     C                   EXFMT     CG3621C0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREXPR - Exit and Previous Screen Processing                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SREXPR        BEGSR
 
     C                   IF        *INKC=*ON
     C                   EVAL      PFunctionKey='03'
     C                   ELSE
     C                   EVAL      PFunctionKey='12'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFRSH - Refresh Subfile Screen                               *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ZA0250                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRFRSH        BEGSR
 
     C                   EVAL      WResetSF='Y'
     C                   EVAL      #0RFFE=*BLANKS
     C                   EVAL      WSavRF=*BLANKS
     C                   EVAL      *IN02=*OFF
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROC - Selection Processing                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ZA0250, SRVALS, SRREFPR                                *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C                   EVAL      *IN02=*OFF
     C                   EVAL      WValid='Y'
     C                   EVAL      PFunctionKey=*BLANKS
 
      ** If 'Position to' field is not blank,
 
     C                   IF        #0RFFE<>*BLANKS
 
     C                   IF        WValid='N'
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
     C                   ENDIF
     C     ':'           SCAN      #0RFFE        WColon
 
     C                   IF        WColon=0 OR WColon=1
 
     C                   EVAL      WPType=#0RFFE
     C                   EVAL      WPSTyp=*BLANKS
 
     C                   ELSE
 
     C                   SUB       1             WColon
     C     WColon        SUBST     #0RFFE:1      WPType
     C                   ADD       2             WColon
     C                   SUBST     #0RFFE:WColon WPSTyp
 
     C                   ENDIF
     C                   ENDIF
 
      ** If there is a change in 'Position to' field, reset subfile.
 
     C                   IF        #0RFFE<>WSavRF
     C                   EVAL      WResetSF='Y'
     C                   ELSE
 
      ** Validate selection fields
 
     C                   IF        WNoData='N'
     C                   EXSR      SRVALS
 
      ** Process selected subfile records.
 
     C                   IF        WValid='Y'
     C                   EXSR      SRREFPR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALS - Validate Selection Field on Subfile                  *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: ZA0250, SRSNMS                                         *
      *                                                               *
      *****************************************************************
 
     C     SRVALS        BEGSR
 
     C                   EVAL      WValid='Y'
     C                   EVAL      WCall35 = 'N'
 
      ** Clear message subfile.
 
     C                   CALL      'ZA0250'
 
      ** Set subfile record pointer to top of subfile
 
     C                   EVAL      #0SFLR=1
     C                   READC     CG3621S0                               08
 
     C                   DOW       *IN08=*OFF
 
     C                   EVAL      PMsgID=*BLANKS
     C                   EVAL      *IN02=*OFF
     C                   EVAL      *IN01=*OFF
 
      ** Selection must be 'A' or 'E' or *BLANK.
 
     C                   IF        #0SELE<>*BLANKS
 
     C                   IF        #0SELE<>'A' AND #0SELE<>'E'
 
     C                   EVAL      WValid='N'
     C                   EVAL      PMsgID='CGD2562'
     C                   EXSR      SRSNMS
     C                   EVAL      *IN02=*ON
 
     C                   ELSE
 
     C                   EVAL      WCall35 = 'Y'
 
     C                   ENDIF
 
      ** Switch *ON SFLNXTCHG
 
     C                   EVAL      *IN01=*ON
 
     C                   ENDIF
 
     C                   UPDATE    CG3621S0
 
     C                   READC     CG3621S0                               08
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRREFPR - Process Selected Reference                          *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: CG3622                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRREFPR       BEGSR
 
      ** Set subfile record pointer to top of subfile
 
     C                   EVAL      #0SFLR=1
 
     C                   READC     CG3621S0                               10
 
     C                   DOW       *IN10=*OFF AND PFunctionKey=*BLANKS
 
     C                   CALLB     'CG3622'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM                    PGroupSetDef
     C                   PARM                    PDescription
     C                   PARM      #0SELE        PSelOption
     C                   PARM      #0ARGT        PReference
     C                   PARM      #0DSCR        PReferDesc
     C                   PARM      #0NWFD        PSchemaNam
     C                   PARM                    PFunctionKey
 
     C                   IF        PFunctionKey=*BLANK
     C                   EVAL      #0SELE=*BLANKS
 
     C                   IF        PSchemaNam=*BLANKS
     C                   EVAL      #0NWFD=PText1
     C                   ELSE
     C                   EVAL      #0NWFD=PSchemaNam
     C                   ENDIF
 
     C                   UPDATE    CG3621S0
     C                   READC     CG3621S0                               10
 
     C                   ELSE
 
     C                   IF        PFunctionKey='12'
     C                   EVAL      #0SELE=*BLANKS
 
     C                   UPDATE    CG3621S0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        PFunctionKey=*BLANKS AND WCall35 = 'Y'
     C                   EVAL      WResetSF='Y'
     C                   EVAL      *IN10 = *OFF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0                                               *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    PReturnCode
     C                   PARM                    PGroupSetDef
     C                   PARM                    PDescription
     C                   PARM                    PFunctionKey
 
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      *BLANKS       DSFDY
 
     C                   IF        PRtnCode<>*BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBPGM  =  'CG3621'
     C                   EVAL      DBASE  =  001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WSubfPag=4
     C                   EVAL      #1PGM = PSProcName
     C                   EVAL      #0USER = PsUser
     C                   EVAL      #0WSID = PsJobName
     C                   EVAL      #0MRDT = BJMRDT
     C                   EVAL      PMsgFile = 'CGUSRMSG'
 
      ** Extract message '*UNDEFINED' via CLP CGC0100.
 
     C                   CALL      'CGC0100'
     C                   PARM      'CGD2583'     PMsgID
     C                   PARM                    PMsgFile
     C                   PARM      *BLANKS       PMsgData
     C                   PARM      *BLANKS       PText1
     C                   PARM      *BLANKS       PText2
     C                   PARM      *BLANKS       PRtnCode
 
      ** Database error if message id does not exist.
 
     C                   IF        PRtnCode = '*NRF   '
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = PMsgFile
     C                   EVAL      DBKEY = PMsgID
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     KEYCgptyp     KLIST
     C                   KFLD                    KGrpSet
     C                   KFLD                    KPType
     C                   KFLD                    KPSTyp
 
     C     KEYCgrdec     KLIST
     C                   KFLD                    KType
     C                   KFLD                    KArgt
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: *INZSR                                                 *
      *                                                                   *
      * Calls: DBERRCTL                                                   *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
