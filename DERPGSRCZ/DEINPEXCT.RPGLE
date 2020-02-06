     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Input extract control information')           *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export Module                                   *
      *                                                               *
      *  DEINPEXCT - INPUT EXTRACT CONTROL INFORMATION                *
      *                                                               *
      *  Function:  This input function allows extract control        *
      *             details to be amended.                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE004             Date 02Jul01               *
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (recompiled)                                        *
      *  208221 - Set up configuration data into data area for        *
      *           array sizes for each member                         *
      *  CDE004 - Cross Modular History Extract                       *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *           Add revenue default base rate code to screen.       *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
     FDEINPEXDF CF   E             WORKSTN        INFSR(*PSSR)
     FDEOLEJPD  IF A E             DISK    COMMIT INFSR(*PSSR)
     FSDCURRL0  IF   E           K DISK           INFSR(*PSSR)                                CDE002
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)                                  CDE002
      ** EXTERNAL DS FOR BASE RATE CODE DETAILS                                               CDE002
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DEEXTCTL      E DS                  EXTNAME(DEEXTCTL)
      ** EXTRACT CONTROL DATA
     D**ExtData*               1     32                                                       CDE002
     D  ExtData                1     34                                                       CDE002
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     DWKRDFRERR        S              1    INZ(' ')                                           CDE002
      ** Warning flag for Default Funding Rate                                                CDE002
                                                                                              CDE002
     D CDE002          S              1A   INZ('N')                                           CDE004
     D CDE004          S              1A   INZ('N')                                           CDE004
     D WkNum           S              4  0                                                    CDE004
                                                                                              CDE004
     D ZFIELD          S             16A                                                      CDE004
     D ZADEC           S              1P 0                                                    CDE004
     D ZADIG           S              2P 0                                                    CDE004
     D ZALIGNok        S              1A                                                      CDE004
                                                                                              CDE004
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Return parameter set if DEEXTCTL data changed
 
     C     *ENTRY        PLIST
     C                   PARM                    EXCT_CHG          1
 
      **  Main processing
      **  Loop until CK/3 taken
 
     C     *INKC         DOWEQ     '0'
     C                   EXSR      MAIN
     C                   END
      *
      * TERMINATE PROGRAM
      *
     C                   MOVE      '1'           *INLR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN PROCESSING
      *****************************************************************
     C     MAIN          BEGSR
 
      ** Selection screen
 
     C                   TIME                    DDTIME
     C                   WRITE     DEEXCTS0
     C                   WRITE     DEEXCTD1
     C                   WRITE     DEEXCTF1
     C                   READ      DEEXCTD1                               99
 
      ** Validate screen input as long as F3 is not taken
 
     C     *INKC         IFEQ      '0'
     C                   EXSR      VALSIN
     C                   ENDIF
      *
      * If no errors, update extract control details on data-area
      *
     C     *IN50         IFEQ      '0'
     C                   MOVEL     'Y'           EXCT_CHG
     C     *LOCK         IN        DEEXTCTL
     C                   MOVEL     DDPCOD        DEPCOD
     C                   MOVEL     DDPCOM        DEPCOM
     C                   MOVEL     DDPCOY        DEPCOY
     C                   MOVEL     DDHCOD        DEHCOD
     C                   MOVEL     DDDPSV        DEDPSV
     C                   MOVEL     DDRDFR        DERDFR                                       CDE002
     C*                                                                                       CDE002
     C** Set Revenue Take-on date to be system run date if CDE002 is on and                   CDE002
     C** date has not previously been set.                                                    CDE002
     C                   IF        *IN21 = *Off and DETKON = 0                                CDE002
     C                   EVAL      DETKON = BJRDNB                                            CDE002
     C                   ENDIF                                                                CDE002
     C                                                                                        CDE002
     C                   IF        CDE004 = 'Y'                                               CDE004
     C                   MOVEL     #1PDDL        DEPDDL                                       CDE004
     C                   MOVEL     #1PDFR        DEPDFR                                       CDE004
     C                   MOVEL     #1PDFT        DEPDFT                                       CDE004
     C                   MOVEL     #1PDFF        DEPDFF                                       CDE004
     C                   MOVEL     #1PDLF        DEPDLF                                       CDE004
     C                   MOVEL     #1PDCE        DEPDCE                                       CDE004
     C                   ENDIF                                                                CDE004
     C*                                                                         208221
     C** Set up configuration data for array sizes.                             208221
     C                   IF        DEHACCR = *BLANKS                            208221
     C                   EVAL      DEHACCR = 'L'                                208221
     C                   EVAL      DEPFEES = 'L'                                208221
     C                   EVAL      DEPSBPS = 'L'                                208221
     C*                                                                         208221
     C                   EVAL      DEHACCT = ' '                                208221
     C                   EVAL      DEHFCLT = ' '                                208221
     C                   EVAL      DEHLOAN = ' '                                208221
     C                   EVAL      DEPACCT = ' '                                208221
     C                   EVAL      DEPFUND = ' '                                208221
     C                   EVAL      DEPLDCL = ' '                                208221
     C                   EVAL      DEPLOAN = ' '                                208221
     C*                                                                         208221
     C                   EVAL      DEHSTRD = 'S'                                208221
     C                   EVAL      DEPCFCO = 'S'                                208221
     C                   EVAL      DEPCUSX = 'S'                                208221
     C                   EVAL      DEPEXTR = 'S'                                208221
     C                   EVAL      DEPFRAS = 'S'                                208221
     C                   EVAL      DEPFXDL = 'S'                                208221
     C                   EVAL      DEPLDNI = 'S'                                208221
     C                   EVAL      DEPNASP = 'S'                                208221
     C                   EVAL      DEPOTCC = 'S'                                208221
     C                   EVAL      DEPSTRD = 'S'                                208221
     C                   EVAL      DEPSWAP = 'S'                                208221
     C                   ENDIF                                                  208221
     C*                                                                         208221
     C                   OUT       DEEXTCTL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALSIN   - VALIDATE SCREEN INPUT
      *****************************************************************
     C     VALSIN        BEGSR
      *
      ** Clear the message queue & init error indicators
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
     C                   MOVE      '0'           *IN50
     C                   MOVEA     '0000000000'  *IN(10)
     C                   MOVEA     '000000'      *IN(32)                                      CDE004
      *
      ** Projected days must be numeric
      *
     C                   TESTN                   DDPCOD               9898
     C     *IN98         IFNE      '1'
     C                   MOVEL     'DEP0020'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   ELSE
      *
      ** Projected days must not be less than 7.
      *
     C                   MOVEL     DDPCOD        @NUMB30           3 0
     C     @NUMB30       IFLT      7
     C                   MOVEL     'DEP0020'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN10
     C                   END
     C                   END
      *
      ** Projected months must be numeric
      *
     C                   TESTN                   DDPCOM               9898
     C     *IN98         IFNE      '1'
     C                   MOVEL     'DEP0021'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN11
     C                   ELSE
      *
      ** Projected months must be less than or equal to 12
      ** and not less than zero.
      *
     C                   MOVEL     DDPCOM        @NUMB20           2 0
     C     @NUMB20       IFGT      12
     C     @NUMB20       ORLT      0
     C                   MOVEL     'DEP0021'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN11
     C                   END
     C                   END
      *
      ** Projected years must be numeric
      *
     C                   TESTN                   DDPCOY               9898
     C     *IN98         IFNE      '1'
     C                   MOVEL     'DEP0022'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN12
     C                   ELSE
      *
      ** Projected years must not be less than zero.
      *
     C                   MOVEL     DDPCOY        @NUMB20
     C     @NUMB20       IFLT      0
     C                   MOVEL     'DEP0022'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN12
     C                   END
     C                   END
      *
      ** Historic days must be numeric
      *
     C                   TESTN                   DDHCOD               9898
     C     *IN98         IFNE      '1'
     C                   MOVEL     'DEP0023'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN13
     C                   ELSE
      *
      ** Historic days must be greater than or equal to 366.
      *
     C                   MOVEL     DDHCOD        @NUMB30
     C     @NUMB30       IFLT      366
     C                   MOVEL     'DEP0023'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN13
     C                   END
     C                   END
      *
      ** Departmental server must be entered
      *
     C                   MOVEL     DDDPSV        @ALPL             1
     C                   MOVE      DDDPSV        @ALPR             1
     C     @ALPL         IFEQ      ' '
     C     @ALPR         OREQ      ' '
     C                   MOVEL     'DEP0024'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      '1'           *IN14
     C                   END
      *
      ** Revenue Default Funding Rate                                                         CDE002
                                                                                              CDE002
      * If CDE002 is on                                                                       CDE002
                                                                                              CDE002
     C                   IF        *IN21 = *OFF                                               CDE002
     C                   MOVEL     DDRDFR        @NUMB20                                      CDE002
                                                                                              CDE002
      * Proceed if there is no warning or rate on screen has changed                          CDE002
                                                                                              CDE002
     C                   IF        WKRDFRERR <> 'Y'                                           CDE002
     C                             or DERDFR <> @NUMB20                                       CDE002
                                                                                              CDE002
     C                   MOVEL     DDRDFR        DERDFR                                       CDE002
     C                   EVAL      WKRDFRERR = *BLANKS                                        CDE002
                                                                                              CDE002
      * Rate entered may not be blank                                                         CDE002
                                                                                              CDE002
     C                   IF        DDRDFR = *BLANKS                                           CDE002
     C                   MOVEL     'DEP0025'     ZAMSID                                       CDE002
     C                   EXSR      ZASNMS                                                     CDE002
     C                   EVAL      *IN15 = *ON                                                CDE002
     C                   ENDIF                                                                CDE002
                                                                                              CDE002
      * Rate entered must be valid numeric between 1 and 99                                   CDE002
                                                                                              CDE002
     C                   IF        *IN15 = *OFF                                               CDE002
     C                   TESTN                   DDRDFR               9898                    CDE002
                                                                                              CDE002
     C                   IF        *IN98 = '0' or                                             CDE002
     C                             DERDFR < 1 or DERDFR > 99                                  CDE002
     C                   EVAL      *IN15 = *ON                                                CDE002
     C                   MOVEL     'DEP0026'     ZAMSID                                       CDE002
     C                   EXSR      ZASNMS                                                     CDE002
     C                   ENDIF                                                                CDE002
                                                                                              CDE002
     C                   ENDIF                                                                CDE002
                                                                                              CDE002
      * Warning if rate not defined for all Dealing currencies                                CDE002
                                                                                              CDE002
     C                   IF        *IN15 = *OFF                                               CDE002
                                                                                              CDE002
     C     *LOVAL        SETLL     SDCURRL0                                                   CDE002
     C                   READ      SDCURRL0                               99                  CDE002
                                                                                              CDE002
     C                   DOW       *IN99 = *OFF and WKRDFRERR <> 'Y'                          CDE002
                                                                                              CDE002
     C                   IF        A6DLCI = 'Y'                                               CDE002
     C                   CALL      'AOBSRTR0'                                                 CDE002
     C                   PARM      *BLANKS       @Return           7                          CDE002
     C                   PARM      '*KEY   '     @Option           7                          CDE002
     C                   PARM      A6CYCD        @Currency         3                          CDE002
     C                   PARM      DDRDFR        @FundingRt        2                          CDE002
     C     SDBSRT        PARM      SDBSRT        DSFDY                                        CDE002
                                                                                              CDE002
      * Rate not defined for at least one currency                                            CDE002
                                                                                              CDE002
     C                   IF        @Return = '*NRF   '                                        CDE002
     C                   MOVEL     'DEP0027'     ZAMSID                                       CDE002
     C                   EXSR      ZASNMSW                                                    CDE002
     C                   EVAL      *IN15 = *ON                                                CDE002
     C                   EVAL      WKRDFRERR = 'Y'                                            CDE002
     C                   ENDIF                                                                CDE002
                                                                                              CDE002
     C                   ENDIF                                                                CDE002
                                                                                              CDE002
     C                   READ      SDCURRL0                               99                  CDE002
     C                   ENDDO                                                                CDE002
                                                                                              CDE002
     C                   ENDIF                                                                CDE002
                                                                                              CDE002
     C                   ENDIF                                                                CDE002
                                                                                              CDE002
     C                   ENDIF                                                                CDE002
                                                                                              CDE004
      ** Validate Retention Days - Dealing                                                    CDE004
                                                                                              CDE004
     C                   IF        CDE004 = 'Y'                                               CDE004
     C                   EVAL      ZFIELD = *Blanks                                           CDE004
     C                   EVAL      ZFIELD = #1PDDL                                            CDE004
     C                   EVAL      ZADEC = 0                                                  CDE004
     C                   EVAL      ZADIG = 4                                                  CDE004
     C                   EXSR      SRChkNum                                                   CDE004
     C                   MOVE      ZFIELD        WkNum                                        CDE004
                                                                                              CDE004
      ** Must be numeric                                                                      CDE004
                                                                                              CDE004
     C                   IF        ZALIGNok = 'N'                                             CDE004
     C                   EVAL      ZAMSID = 'DEP0030'                                         CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   EVAL      *IN32 = *On                                                CDE004
     C                   ELSE                                                                 CDE004
     C                   MOVE      ZFIELD        #1PDDL                                       CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** Must be greater than zero                                                            CDE004
                                                                                              CDE004
     C                   IF        #1PDDL = '0000'                                            CDE004
     C                   EVAL      ZAMSID = 'DEP0031'                                         CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   EVAL      *IN32 = *On                                                CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** If CDE002 is installed, retention days must be equal or greater than                 CDE004
      ** Historic Days                                                                        CDE004
                                                                                              CDE004
     C                   IF        CDE002 = 'Y' and WkNum  < @NUMB30                          CDE004
     C                   EVAL      ZAMSID = 'DEP0032'                                         CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   EVAL      *IN32 = *On                                                CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** Validate Retention Days - FRA/IRS                                                    CDE004
                                                                                              CDE004
     C                   EVAL      ZFIELD = *Blanks                                           CDE004
     C                   EVAL      ZFIELD = #1PDFR                                            CDE004
     C                   EXSR      SRChkNum                                                   CDE004
     C                   MOVE      ZFIELD        WkNum                                        CDE004
                                                                                              CDE004
      ** Must be numeric                                                                      CDE004
                                                                                              CDE004
     C                   IF        ZALIGNok = 'N'                                             CDE004
     C                   EVAL      ZAMSID = 'DEP0030'                                         CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   EVAL      *IN34 = *On                                                CDE004
     C                   ELSE                                                                 CDE004
     C                   MOVE      ZFIELD        #1PDFR                                       CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** Must be greater than zero                                                            CDE004
                                                                                              CDE004
     C                   IF        #1PDFR = '0000'                                            CDE004
     C                   EVAL      ZAMSID = 'DEP0031'                                         CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   EVAL      *IN34 = *On                                                CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** If CDE002 is installed, retention days must be equal or greater than                 CDE004
      ** Historic Days                                                                        CDE004
                                                                                              CDE004
     C                   IF        CDE002 = 'Y' and WkNum  < @NUMB30                          CDE004
     C                   EVAL      ZAMSID = 'DEP0032'                                         CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   EVAL      *IN34 = *On                                                CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** Validate Retention Days - Funds Transfer                                             CDE004
                                                                                              CDE004
     C                   EVAL      ZFIELD = *Blanks                                           CDE004
     C                   EVAL      ZFIELD = #1PDFT                                            CDE004
     C                   EXSR      SRChkNum                                                   CDE004
     C                   MOVE      ZFIELD        WkNum                                        CDE004
                                                                                              CDE004
      ** Must be numeric                                                                      CDE004
                                                                                              CDE004
     C                   IF        ZALIGNok = 'N'                                             CDE004
     C                   EVAL      ZAMSID = 'DEP0030'                                         CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   EVAL      *IN36 = *On                                                CDE004
     C                   ELSE                                                                 CDE004
     C                   MOVE      ZFIELD        #1PDFT                                       CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** Must be greater than zero                                                            CDE004
                                                                                              CDE004
     C                   IF        #1PDFT = '0000'                                            CDE004
     C                   EVAL      ZAMSID = 'DEP0031'                                         CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   EVAL      *IN36 = *On                                                CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** If CDE002 is installed, retention days must be equal or greater than                 CDE004
      ** Historic Days                                                                        CDE004
                                                                                              CDE004
     C                   IF        CDE002 = 'Y' and WkNum  < @NUMB30                          CDE004
     C                   EVAL      ZAMSID = 'DEP0032'                                         CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   EVAL      *IN36 = *On                                                CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** Validate Retention Days - Futures & Options                                          CDE004
                                                                                              CDE004
     C                   EVAL      ZFIELD = *Blanks                                           CDE004
     C                   EVAL      ZFIELD = #1PDFF                                            CDE004
     C                   EXSR      SRChkNum                                                   CDE004
     C                   MOVE      ZFIELD        WkNum                                        CDE004
                                                                                              CDE004
      ** Must be numeric                                                                      CDE004
                                                                                              CDE004
     C                   IF        ZALIGNok = 'N'                                             CDE004
     C                   EVAL      ZAMSID = 'DEP0030'                                         CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   EVAL      *IN33 = *On                                                CDE004
     C                   ELSE                                                                 CDE004
     C                   MOVE      ZFIELD        #1PDFF                                       CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** Must be greater than zero                                                            CDE004
                                                                                              CDE004
     C                   IF        #1PDFF = '0000'                                            CDE004
     C                   EVAL      ZAMSID = 'DEP0031'                                         CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   EVAL      *IN33 = *On                                                CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** If CDE002 is installed, retention days must be equal or greater than                 CDE004
      ** Historic Days                                                                        CDE004
                                                                                              CDE004
     C                   IF        CDE002 = 'Y' and WkNum  < @NUMB30                          CDE004
     C                   EVAL      ZAMSID = 'DEP0032'                                         CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   EVAL      *IN33 = *On                                                CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** Validate Retention Days - Lending Fees                                               CDE004
                                                                                              CDE004
     C                   EVAL      ZFIELD = *Blanks                                           CDE004
     C                   EVAL      ZFIELD = #1PDLF                                            CDE004
     C                   EXSR      SRChkNum                                                   CDE004
     C                   MOVE      ZFIELD        WkNum                                        CDE004
                                                                                              CDE004
      ** Must be numeric                                                                      CDE004
                                                                                              CDE004
     C                   IF        ZALIGNok = 'N'                                             CDE004
     C                   EVAL      ZAMSID = 'DEP0030'                                         CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   EVAL      *IN35 = *On                                                CDE004
     C                   ELSE                                                                 CDE004
     C                   MOVE      ZFIELD        #1PDLF                                       CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** Must be greater than zero                                                            CDE004
                                                                                              CDE004
     C                   IF        #1PDLF = '0000'                                            CDE004
     C                   EVAL      ZAMSID = 'DEP0031'                                         CDE004
     C                   EVAL      *IN35 = *On                                                CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** If CDE002 is installed, retention days must be equal or greater than                 CDE004
      ** Historic Days                                                                        CDE004
                                                                                              CDE004
     C                   IF        CDE002 = 'Y' and WkNum  < @NUMB30                          CDE004
     C                   EVAL      ZAMSID = 'DEP0032'                                         CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   EVAL      *IN35 = *On                                                CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** Validate Retention Days - Retail Customer Exchange                                   CDE004
                                                                                              CDE004
     C                   EVAL      ZFIELD = *Blanks                                           CDE004
     C                   EVAL      ZFIELD = #1PDCE                                            CDE004
     C                   EXSR      SRChkNum                                                   CDE004
     C                   MOVE      ZFIELD        WkNum                                        CDE004
                                                                                              CDE004
      ** Must be numeric                                                                      CDE004
                                                                                              CDE004
     C                   IF        ZALIGNok = 'N'                                             CDE004
     C                   EVAL      ZAMSID = 'DEP0030'                                         CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   EVAL      *IN37 = *On                                                CDE004
     C                   ELSE                                                                 CDE004
     C                   MOVE      ZFIELD        #1PDCE                                       CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** Must be greater than zero                                                            CDE004
                                                                                              CDE004
     C                   IF        #1PDCE = '0000'                                            CDE004
     C                   EVAL      ZAMSID = 'DEP0031'                                         CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   EVAL      *IN37 = *On                                                CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** If CDE002 is installed, retention days must be equal or greater than                 CDE004
      ** Historic Days                                                                        CDE004
                                                                                              CDE004
     C                   IF        CDE002 = 'Y' and WkNum  < @NUMB30                          CDE004
     C                   EVAL      ZAMSID = 'DEP0032'                                         CDE004
     C                   EXSR      ZASNMS                                                     CDE004
     C                   EVAL      *IN37 = *On                                                CDE004
     C                   ENDIF                                                                CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE002
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CDE004
      *****************************************************************                       CDE004
      *                                                               *                       CDE004
      * SRChkNum - Subroutine to check if Retention Days is numeric   *                       CDE004
      *                                                               *                       CDE004
      * Called by: VALSIN                                             *                       CDE004
      *                                                               *                       CDE004
      * Calls:     ZALIGN                                             *                       CDE004
      *                                                               *                       CDE004
      *****************************************************************                       CDE004
     C     SRChkNum      BEGSR                                                                CDE004
                                                                                              CDE004
     C                   CALLB     'ZALIGN'                                                   CDE004
     C                   PARM                    ZALIGNok                                     CDE004
     C                   PARM                    ZFIELD                                       CDE004
     C                   PARM                    ZADEC                                        CDE004
     C                   PARM                    ZADIG                                        CDE004
                                                                                              CDE004
     C                   ENDSR                                                                CDE004
      *****************************************************************                       CDE004
      /EJECT
      *****************************************************************
      * ZASNMS - SEND A MESSAGE
      *****************************************************************
     C     ZASNMS        BEGSR
 
     C                   CALL      'Y2SNMGC'                            9999    *
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM      'MIDAS'       ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
 
      * Error encountered
 
     C                   MOVE      '1'           *IN50
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CDE002
      * ZASNMSW - SEND A WARNING MESSAGE                                                      CDE002
      *****************************************************************                       CDE002
     C     ZASNMSW       BEGSR                                                                CDE002
                                                                                              CDE002
     C                   CALL      'Y2SNMGC'                            9999                  CDE002
     C                   PARM      DDPGM         ZAPGMQ           10                          CDE002
     C                   PARM                    ZAPGRL            5                          CDE002
     C                   PARM                    ZAMSID            7                          CDE002
     C                   PARM      'MIDAS'       ZAMSGF           10                          CDE002
     C                   PARM                    ZAMSDA          132                          CDE002
     C                   PARM                    ZAMSTP            7                          CDE002
                                                                                              CDE002
     C                   ENDSR                                                                CDE002
      *****************************************************************                       CDE002
      /EJECT                                                                                  CDE002
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'DEINPEXCT'   DDPGM
      *
      ** Set up subfile message queue information
      *
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
      *
      ** Set up standard screen fields.
      *
     C                   MOVEL     PsJobName     DDJOB
     C                   MOVEL     PsUser        DDUSR
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '900'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS SAR DETAILS FOR CCRM Limits
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CDE001'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 905 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      * Protect/non-display screen fields
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     '1'           *IN20
     C                   END
      *
      ** ACCESS SAR DETAILS FOR CCRM Revenue Analysis
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CDE002'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 905 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      * Protect/non-display screen fields
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     '1'           *IN21
     C                   ELSE                                                                 CDE004
     C                   EVAL      CDE002 = 'Y'                                               CDE004
     C                   END
                                                                                              CDE004
      ** Access SAR Detailf for Cross Modular History Extract                                 CDE004
                                                                                              CDE004
     C                   CALL      'AOSARDR0'                                                 CDE004
     C                   PARM      *BLANKS       @RTCD                                        CDE004
     C                   PARM      '*VERIFY'     @OPTN                                        CDE004
     C                   PARM      'CDE004'      @SARD                                        CDE004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDE004
                                                                                              CDE004
     C                   IF        @RTCD = *Blanks                                            CDE004
     C                   EVAL      CDE004 = 'Y'                                               CDE004
     C                   EVAL      *IN31  = *On                                               CDE004
     C                   ELSE                                                                 CDE004
     C                   EVAL      *IN31  = *Off                                              CDE004
     C                   ENDIF                                                                CDE004
                                                                                              CDE004
      ** Database Error                                                                       CDE004
                                                                                              CDE004
     C                   IF        @RTCD <> *Blanks and @RTCD <> '*NRF   '                    CDE004
     C                   MOVEL     'CDE004'      DBKEY                                        CDE004
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDE004
     C                   MOVEL     '903'         DBASE                                        CDE004
     C                   EXSR      *PSSR                                                      CDE004
     C                   END                                                                  CDE004
 
      * Get extract control data
 
     C     *DTAARA       DEFINE                  DEEXTCTL
     C     *LOCK         IN        DEEXTCTL
 
      * Default if no details
 
     C     ExtData       IFEQ      *BLANK
     C                   MOVEL     'Y'           EXCT_CHG
     C                   Z-ADD     7             DEPCOD
     C                   Z-ADD     0             DEPCOM
     C                   Z-ADD     0             DEPCOY
     C                   Z-ADD     366           DEHCOD
     C                   Z-ADD     0             DEPCDT
     C                   Z-ADD     0             DEHCDT
     C                   MOVEL     'CS'          DEDPSV
     C                   Z-ADD     0             DEPRDNB
     C                   Z-ADD     0             DEPDNWD
     C                   Z-ADD     0             DEHRDNB
     C                   Z-ADD     0             DEHDNWD
     C                   MOVEL     'Y'           DECHKD
     C                   Z-ADD     1             DERDFR                                       CDE002
     C                   Z-ADD     0             DETKON                                       CDE002
     C                   ENDIF
     C                   OUT       DEEXTCTL
 
      * Set screen fields
 
     C                   MOVEL     DEPCOD        DDPCOD
     C                   MOVEL     DEPCOM        DDPCOM
     C                   MOVEL     DEPCOY        DDPCOY
     C                   MOVEL     DEHCOD        DDHCOD
     C                   MOVEL     DEDPSV        DDDPSV
     C                   MOVEL     DERDFR        DDRDFR                                       CDE002
     C                   IF        CDE004 = 'Y'                                               CDE004
     C                   MOVEL     DEPDDL        #1PDDL                                       CDE004
     C                   MOVEL     DEPDFR        #1PDFR                                       CDE004
     C                   MOVEL     DEPDFT        #1PDFT                                       CDE004
     C                   MOVEL     DEPDFF        #1PDFF                                       CDE004
     C                   MOVEL     DEPDLF        #1PDLF                                       CDE004
     C                   MOVEL     DEPDCE        #1PDCE                                       CDE004
     C                   ENDIF                                                                CDE004
 
      * Write a record to the on-line extract journal seq. no. file
      * if one does not currently exist.
 
     C     1             CHAIN     DEOLEJPD                           99
     C     *IN99         IFEQ      '1'
     C                   EVAL      I#LASTSEQ = '0000000001'
     C                   WRITE     DEOLEJP0
     C                   ENDIF
 
      * Commit the update
 
     C                   COMMIT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
