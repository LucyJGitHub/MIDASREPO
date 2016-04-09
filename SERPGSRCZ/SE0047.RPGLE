     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
 
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Security detail maintenance - tax details')
      *****************************************************************
      *                                                               *
      *  Midas - Windows                                              *
      *                                                               *
      *  SE0047 - Securities Maintenance Withholding Tax Details      *
      *                                                               *
      *  Function:  This program will be called from the securities   *
      *             maintenance, if CSE023 is switched on, to allow   *
      *             user to define the withholding tax details.       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CER001             Date 25Apr05               *
      *                 220008             Date 28Jul03               *
      *                 BUG3644            Date 12Jul04               *
      *                 CGP001             Date 18Dec03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 207408             Date 08Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185292             Date 20Oct00               *
      *                 CSE023  *Create    Date 12Jul00               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CER001 - LUX Upgrade to Midas Plus                           *
      *           Applied fix MLPFIX from Lux                         *
      *  220008 - Securities input accepts country of tax which does  *
      *           not exist in SDWHTTPD. Fix is to add validation.    *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CGP001 - Global Processing (Recompile)                       *
      *  207408 - Details are not reset if insertion after an "USD"   *
      *  185292 - Change in the processing of OID for client without  *
      *           documentation.                                      *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *  20 - Enquiry Mode                                            *
      *  21 - Non-display of fields for Processing Types 2, 4 and 7   *
      *  50 - Global error indicator                                  *
      *  51 - Error in Country of Tax Treaty                          *
      *  52 - Error in Income Code                                    *
      *  53 - Error in Exemption Code                                 *
      *  54 - Error in Original Interest Discount Indicator           *
      *  55 - Error in Portfolio Interest Exemption Indicator         *
      *  80 - No find for Chain to files                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRClear - Clear Message Subfile                              *
      *  SREnd   - Exit from program                                  *
      *  SRExit  - Exit from program if F3 has been pressed           *
      *  SRPrev  - Exit from program if F12 has been pressed          *
      *  SRValid - Validate the screen                                *
      *                                                               *
      *  *PSSR   - Program exception error routine                    *
      *  ZASNMS  - Send message to program's message queue            *
      *                                                               *
      *****************************************************************
     FSDEXEML1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDEXEMD0:@EXEML1)
     FSDINCCL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDINCCD0:@INCCL1)
     FSDWHTTL5  IF   E           K DISK    INFSR(*PSSR)                                       220008
     FSE0047DF  CF   E             WORKSTN INFSR(*PSSR)
      *****************************************************************
      /EJECT
      /COPY ZACPYSRC,STD_D_SPEC
      /COPY ZACPYSRC,PSDS
      *
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      ** External DS for Country Codes
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access programs, long data structure
      *
     D SPARE1          DS           256
     D  Val1st                 1      1
                                                                                              CER001
     D  WUCF12               246    246                                                       CER001
                                                                                              CER001
      /COPY QWINDSRC,SE0047GDTA
      ** Data member for main program
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *
      **   Standard parameter list for window manager
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN              1
     C                   PARM                    DATA
     C                   PARM                    W0RTN             7
     C                   PARM                    WLEN              3 0
     C                   PARM                    WWID              3 0
     C                   PARM                    SROW              3 0
     C                   PARM                    SCOL              3 0
     C                   PARM                    TITLE             7
     C                   PARM                    SPARE1
      *
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
      *
      *****************************************************************
 
     C                   IF        Val1st = 'Y'
     C                   EXSR      SRValid
     C                   ENDIF
 
     C                   WRITE     SE0047F1
     C                   WRITE     SE0047F0
     C                   MOVE      *ON           *IN50
 
      ** Continue to redisplay the screen if *IN50 remains on
 
     C     *IN50         DOWEQ     *ON
 
      ** If error write messages
 
     C                   WRITE     #MSGCTL
     C                   EXFMT     SE0047F0
     C                   EXSR      SRClear
 
     C     *INKC         CASEQ     '1'           SRExit
     C     *INKL         CASEQ     '1'           SRPrev
     C                   CAS                     SRValid
     C                   ENDCS
     C                   ENDDO
 
     C                   MOVE      SCRTT         #1CRTT
     C                   MOVE      SINCT         #1INCT
     C                   MOVE      SEXEM         #1EXCD
     C                   MOVE      SOIDI         #1OIDI
     C                   MOVE      SAPIE         #1APIE
 
      ** Exit from program
 
     C                   EXSR      SREnd
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClear - Clear Message Subfile                              *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     Y2CLMSC                                           *
      *                                                               *
      *****************************************************************
     C     SRClear       BEGSR
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - Exit from proram                                     *
      *                                                               *
      *  Called by: Main Processing                                   *
      *             SRExit                                            *
      *             SRPrev                                            *
      *             SRValid                                           *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SREnd         BEGSR
 
     C                   EVAL      *INLR = *On
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExit - Exit from program if F3 has been pressed            *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SREnd                                             *
      *                                                               *
      *****************************************************************
     C     SRExit        BEGSR
 
     C                   EVAL      W0RTN = 'Y2U9999'
     C                   EXSR      SREnd
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:     SDRTVTXT                                          *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
 
      ** Check if CSE023 is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *Blanks       PRetCode          7
     C                   PARM      '*VERIFY'     POption           7
     C                   PARM      'CSE023'      PSAR              6
 
     C                   IF        PRetCode <> *Blanks
      *                                                                                       CER001
      ** If not and F12 was taken on the following window, indicates to                       CER001
      ** the window controller that it has to display the previous                            CER001
      ** window                                                                               CER001
      *                                                                                       CER001
     C                   IF        WUCF12 = 'R'                                               CER001
     C                   EXSR      SRPrev                                                     CER001
      *                                                                                       CER001
      ** Else, simply terminate the module                                                    CER001
      *                                                                                       CER001
     C                   ELSE                                                                 CER001
     C                   EXSR      SREnd
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF
      *                                                                                       CER001
      ** Reset the field used for the F12 processing                                          CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       WUCF12                                       CER001
 
      **   Define window position
 
     C                   Z-ADD     SROW          SWROW
     C                   Z-ADD     SCOL          SWCOL
 
      **   Retrieve title for window
 
     C                   MOVEL     'WNMSGF'      ZAMSGF
     C                   CALL      'SDRTVTXT'
     C                   PARM                    TITLE
     C                   PARM                    ZAMSGF
     C                   PARM                    TEXT            132
     C                   MOVEL     TEXT          STITL
 
      **   Protect input fields if enquiry
 
     C                   IF        ACTN = 'E'
     C                   EVAL      *IN20 = *On
     C                   ELSE
     C                   EVAL      *IN20 = *Off
     C                   ENDIF
 
      ** If Processing Type is 2, 4 or 7
 
     C                   IF        #1PROT = '2' or #1PROT = '4' or
     C                             #1PROT = '7'
     C                   EVAL      *IN21 = *On
     C                   ENDIF
 
     C                   Eval      ##PGM = PsProcName
 
      ** Set up KLIST
 
     C     KEY1          KLIST
     C                   KFLD                    KCRTT             2
     C                   KFLD                    KINCT             2
 
     C     KEY2          KLIST
     C                   KFLD                    KCRTT
     C                   KFLD                    KEXEM             2
 
     C     KEY3          KLIST                                                                220008
     C                   KFLD                    KCRTT                                        220008
     C                   KFLD                    KSITP             3                          220008
                                                                                              220008
      ** Move to screen fields
 
     C     ACTN          IFNE      'I'                                                        207408
     C                   EVAL      SCRTT = #1CRTT
     C                   EVAL      SINCT = #1INCT
     C                   EVAL      SEXEM = #1EXCD
     C                   EVAL      SOIDI = #1OIDI
     C                   EVAL      SAPIE = #1APIE
     C                   ELSE                                                                 207408
     C                   MOVEL     *BLANKS       #1CRTT                                       207408
     C                   MOVEL     *BLANKS       #1INCT                                       207408
     C                   MOVEL     *BLANKS       #1EXCD                                       207408
     C                   MOVEL     *BLANKS       #1OIDI                                       207408
     C                   MOVEL     *BLANKS       #1APIE                                       207408
     C                   ENDIF                                                                207408
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrev - Exit from program if F12 has been pressed           *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SREnd                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRPrev        BEGSR
 
      **   Set F12 return code and end program
 
     C                   EVAL      W0RTN = 'USR0790'
     C                   EVAL      WUCF12 = 'R'                                               CER001
     C                   EXSR      SREnd
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValid - Validate the screen                                *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     AOCTRYR0                                          *
      *             SREnd                                             *
      *             ZASNMS                                            *
      *                                                               *
      *****************************************************************
     C     SRValid       BEGSR
 
     C                   MOVEA     '000000'      *IN(50)
 
      ** If the action code is enquire then simply exit from program
 
     C                   IF        ACTN = 'E'
     C                   EXSR      SREnd
     C                   ENDIF
 
      ** Validate Country of tax treaty (SCRTT)
 
     C     SCRTT         IFNE      *BLANKS
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      SCRTT         PCTRY             2
     C     SDCTRY        PARM      SDCTRY        DSSDY
 
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN51
     C                   MOVE      'WNE0101'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   MOVE      SCRTT         KCRTT                                        220008
     C                   MOVE      #1SITP        KSITP                                        220008
     C     KEY3          CHAIN     SDWHTTL5                           80                      220008
     C     *IN80         IFEQ      '1'                                                        220008
     C                   MOVE      *BLANKS       KSITP                                        220008
     C     KEY3          CHAIN     SDWHTTL5                           80                      220008
     C     *IN80         IFEQ      '1'                                                        220008
     C                   MOVE      '1'           *IN50                                        220008
     C                   MOVE      '1'           *IN51                                        220008
     C                   MOVE      'WNE0101'     ZAMSID                                       220008
     C                   EXSR      ZASNMS                                                     220008
     C                   ELSE                                                                 220008
     C                   MOVE      A4CNCD        SCRTT
     C                   ENDIF                                                                220008
     C                   ELSE                                                                 220008
     C                   MOVE      A4CNCD        SCRTT                                        220008
     C                   ENDIF                                                                220008
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate Income Type (SINCT)
 
     C                   MOVE      SCRTT         KCRTT
 
     C     *IN51         IFEQ      *Off
     C     SCRTT         IFNE      *BLANKS
     C     SINCT         ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN52
     C                   MOVE      'WNE0102'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
 
     C     SINCT         IFNE      *BLANKS
     C                   MOVE      SINCT         KINCT
     C     KEY1          CHAIN     @INCCL1                            80
     C     *IN80         IFEQ      *ON
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN52
     C                   MOVE      'WNE0103'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Exemption Code (SEXEM)
 
     C     SEXEM         IFNE      *BLANKS
     C     *IN51         ANDEQ     *Off
     C                   MOVE      SEXEM         KEXEM
     C     KEY2          CHAIN     @EXEML1                            80
     C     *IN80         IFEQ      *ON
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN53
     C                   MOVE      'WNE0104'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
 
      ** If Processing type is not 2, not 4 and not 7
 
     C                   IF        #1PROT <> '2' and #1PROT <> '4' and
     C                             #1PROT <> '7'
 
      ** Validate Original Interest Discount (SOID)
 
     C     SOIDI         IFNE      'Y'
     C     SOIDI         ANDNE     'N'
     C     SOIDI         ANDNE     'S'                                                      185292
     C     SOIDI         ANDNE     *BLANKS
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN54
     C                   MOVE      'WNE0105'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
 
     C     SOIDI         IFEQ      *BLANKS
     C                   MOVE      'N'           SOIDI
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Portfolio Interest Exemption (SPOIE)
 
     C     SAPIE         IFNE      'Y'
     C     SAPIE         ANDNE     'N'
     C     SAPIE         ANDNE     *BLANKS
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN55
     C                   MOVE      'WNE0106'     ZAMSID
     C                   EXSR      ZASNMS
 
     C                   ELSE
 
     C     SAPIE         IFEQ      *BLANKS
     C                   MOVE      'Y'           SAPIE
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS - Send message to program's message queue             *
      *                                                               *
      *  Called by: SRValid                                           *
      *                                                               *
      *  Calls:     Y2SNMGC                                           *
      *                                                               *
      *****************************************************************
 
     C     ZASNMS        BEGSR
 
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ           10
     C                   ENDIF
 
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
 
     C     ZAEXIT        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
 
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   ENDIF
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
