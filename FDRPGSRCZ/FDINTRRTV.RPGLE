     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD MM Int. Rates Act/Ccy Validation')            *
      *****************************************************************
      *                                                               *
      *  Midas - Fixed Data Module                                    *
      *                                                               *
      *  FDINTRRTV - FD MM Interest Rates Retrieve                    *
      *              (with Action Code versus Currency Validation)    *
      *                                                               *
      *  Function:  This module validates the implied action code of  *
      *             'I' against currency code.                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 13Jul00               *
      *                 CAP058             Date 01May01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP005  *CREATE    Date 17Oct98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP058 - Full API for Money Market Interest Rates            *
      *  CAP005 - Conversion of Citydealer Rates upload to use APIs   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFDINTRLL  IF   E           K DISK    INFSR(*PSSR)
     FSDCURRLA  IF   E           K DISK    INFSR(*PSSR)                         CAP058
     F                                     RENAME(SDCURRD0:SDCURRA)             CAP058
     FSDCURRLB  IF   E           K DISK    INFSR(*PSSR)                         CAP058
     F                                     RENAME(SDCURRD0:SDCURRB)             CAP058
     FFDINTRL0  IF   E           K DISK    INFSR(*PSSR)                         CAP058
     F                                     RENAME(FDINTRP0:FDIRFO0)             CAP058
     FFDINTRL1  IF   E           K DISK    INFSR(*PSSR)                         CAP058
     F                                     RENAME(FDINTRP0:FDIRFO1)             CAP058
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** Borrowing Rates
     D @@BR            S             11  7 DIM(21)                              BORROW RATES
      ** Lending Rates
     D @@LR            S             11  7 DIM(21)                              LEND RATES
                                                                                CAP058
      ** Extra Data                                                             CAP058
     D @@EX            S              4A   DIM(21)                              CAP058
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
                                                                                CAP058
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP058
      ** EXTERNAL DS FOR API ICD                                                CAP058
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP058
      ** External DS for Switchable Features                                    CAP058
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D INTRFilFmt    E DS                  EXTNAME(FDVINTRPD)
      ** MM Interest Rates record in File Format
                                                                                CAP058
     D ValWrkFlds    E DS                  EXTNAME(FDWINTRPD)                   CAP058
      ** Interest Rates Validation Workfields                                   CAP058
 
     D ZMUSER        E DS                  EXTNAME(ZMUSER)
      ** Obtain default branch for user
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
                                                                                CAP058
      ** Access security checking                                               CAP058
                                                                                CAP058
     C     Respmode      IFEQ      'S'                                          CAP058
     C                   EXSR      SecChk                                       CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
      ** If the mode is 'FRONT OFFICE TRANSACTION INTERFACE'                    CAP058
      ** Do (extra) validation for FRONT OFFICE TRANSACTION INTERFACE           CAP058
                                                                                CAP058
     C     CAP058        IFEQ      'Y'                                          CAP058
     C     ModeOfOp      ANDEQ     '*FRONT'                                     CAP058
     C                   EXSR      SrVFRNT                                      CAP058
                                                                                CAP058
      **  Carry out no further validation if errors have occurred.              CAP058
                                                                                CAP058
     C     OKACTN        IFEQ      'N'                                          CAP058
     C     OKCCY         OREQ      'N'                                          CAP058
     C                   RETURN                                                 CAP058
     C                   ENDIF                                                  CAP058
     C                   ENDIF                                                  CAP058
      *
      * VALIDATE CURRENCY CODE
      *
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
      *
     C*****OKACTN        IFEQ      'N'                                          CAP058
     C*****OKCCY*        OREQ      'N'                                          CAP058
     C***********        RETURN                                                 CAP058
     C***********        END                                                    CAP058
      ***********                                                               CAP058
      ****-----------------------------------------------**************         CAP058
      *****Access*Security*Checking************************************         CAP058
      ****-----------------------------------------------**************         CAP058
      **********                                                                CAP058
     C*****RespMode      IFEQ      'S'                                          CAP058
     C***********        EXSR      SecChk                                       CAP058
     C***********        ENDIF                                                  CAP058
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATE CURRENCY CODE
      *****************************************************************
     C     VAL           BEGSR
                                                                                CAP058
      ** Action code is blank default to 'E'                                    CAP058
                                                                                CAP058
     C     DDACTN        IFEQ      *BLANK                                       CAP058
     C     WDFTAC        ANDEQ     'Y'                                          CAP058
     C                   EVAL      DDACTN = 'E'                                 CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
      ** Validate action code                                                   CAP058
                                                                                CAP058
     C                   IF        (DDACTN <> 'A') AND (DDACTN <> 'D') AND      CAP058
     C                             (DDACTN <> 'E') AND (DDACTN <> 'I')          CAP058
     C                   MOVE      'N'           OKACTN                         CAP058
     C                   ADD       1             Ix                             CAP058
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                 CAP058
     C                   MOVEL     'FDM0101'     MsgIdArr(Ix)                   CAP058
     C                   GOTO      EVAL                                         CAP058
     C                   ENDIF                                                  CAP058
      *
      ** Check that the currency code has been entered
      *
     C     DDCCY         IFEQ      *BLANKS
     C     ModeOfOp      ANDNE     '*FRONT'                                     CAP058
     C                   MOVE      'N'           OKCCY
     C                   ADD       1             Ix
     C                   MOVEL     'DDCCY'       FldNameArr(Ix)
     C                   MOVEL     'MMA0705'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
      *
      ** Check that currency code exists
      *  (database error handling done in access program)
      *
     C                   EVAL       DDCYNM = *BLANKS                            CAP058
     C     SubForTRNN    IFEQ      0                                            CAP058
     C     ModeOfOp      ORNE      '*FRONT'                                     CAP058
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      DDCCY         @KEY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           OKCCY
     C                   ADD       1             Ix
     C                   MOVEL     'DDCCY'       FldNameArr(Ix)
     C                   MOVEL     'ABM0009'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
      *
      ** Check that currency code is a valid dealing currency
      *
     C                   EVAL       DDCYNM = A6CYNM                             CAP058
     C     A6DLCI        IFEQ      'N'
     C                   MOVE      'N'           OKCCY
     C                   ADD       1             Ix
     C                   MOVEL     'DDCCY'       FldNameArr(Ix)
     C                   MOVEL     'MMA0706'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *                                                                         CAP058
     C                   ENDIF                                                  CAP058
      *
      ** Define key to FDINTRLL
      *
     C     KINTR         KLIST
     C                   KFLD                    DDCCY
      *
      ** Access MM interest rates records
      *
     C     KINTR         SETLL     FDINTRLL
     C     KINTR         READE     FDINTRLL                               99
 
     C                   Z-ADD     *ZERO         ##X               3 0
     C                   Z-ADD     *ZERO         @@BR
     C                   Z-ADD     *ZERO         @@LR
                                                                                CAP058
     C                   SELECT                                                 CAP058
                                                                                CAP058
     C     DDACTN        WHENEQ    'I'                                          CAP058
                                                                                CAP058
      ** Error when record is active for action 'I'                             CAP058
                                                                                CAP058
     C                   IF        *IN99 = FALSE                                CAP058
     C                   IF        HWDLTF = *BLANK                              CAP058
     C                   MOVE      'N'           OKCCY                          CAP058
     C                   ADD       1             Ix                             CAP058
     C                   MOVEL     'DDCCY'       FldNameArr(Ix)                 CAP058
     C                   MOVEL     'FDM0490'     MsgIdArr(Ix)                   CAP058
     C                   GOTO      EVAL                                         CAP058
     C                   ENDIF                                                  CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
      ** Error when record is already deleted for action 'E','A' or 'D' or      CAP058
      ** does not exist on file                                                 CAP058
                                                                                CAP058
     C                   WHEN      (DDACTN = 'E') OR (DDACTN = 'A') OR          CAP058
     C                             (DDACTN = 'D')                               CAP058
     C                   IF        (*IN99 = TRUE) OR                            CAP058
     C                             (*IN99 = FALSE) AND (HWDLTF = '*')           CAP058
     C                   MOVE      'N'           OKCCY                          CAP058
     C                   ADD       1             Ix                             CAP058
     C                   MOVEL     'DDCCY'       FldNameArr(Ix)                 CAP058
     C                   MOVEL     'FDM0491'     MsgIdArr(Ix)                   CAP058
     C                   GOTO      EVAL                                         CAP058
     C                   ELSE                                                   CAP058
                                                                                CAP058
      ** MDF Feature is On.                                                     CAP058
                                                                                CSD006
     C     CSD006        IFEQ      'Y'                                          CSD006
                                                                                CSD006
      ** Data Request Id/Tolerance Indicator                                    CSD006
                                                                                CSD006
     C                   EVAL      FYDTFR = HWDTFR                              CSD006
     C                   EVAL      FYTLEX = HWTLEX                              CSD006
     C                   EVAL      FYBOFR = HWBOFR                              CSD006
     C                   EVAL      FYBOAF = HWBOAF                              CSD006
     C                   EVAL      FYBORP = HWBORP                              CSD006
     C                   EVAL      FYLEFR = HWLEFR                              CSD006
     C                   EVAL      FYLEAF = HWLEAF                              CSD006
     C                   EVAL      FYLERP = HWLERP                              CSD006
                                                                                CSD006
      ** Move Borrowing/Lending timestamp to valid file data structure          CSD006
                                                                                CSD006
     C                   EVAL      FYBOTS = HWBOTS                              CSD006
     C                   EVAL      FYLETS = HWLETS                              CSD006
     C                   EVAL      FYBOTM = HWBOTM                              CSD006
     C                   EVAL      FYLETM = HWLETM                              CSD006
     C                   ENDIF                                                  CSD006
     C                   ENDIF                                                  CAP058
     C                   ENDSL                                                  CAP058
 
     C     *IN99         DOWEQ     *OFF
 
     C     HWDLTF        IFEQ      *BLANK
     C                   ADD       1             ##X
     C                   Z-ADD     HWBRRT        @@BR(##X)
     C                   Z-ADD     HWLDRT        @@LR(##X)
     C                   MOVEL     HWPRDX        @@EX(##X)                      CAP058
                                                                                CAP058
      ** Setup common fields                                                    CAP058
                                                                                CAP058
     C                   EXSR      SrCOMFLDS                                    CAP058
     C                   ENDIF
 
     C     KINTR         READE     FDINTRLL                               99
     C                   ENDDO
                                                                                CAP058
      ** Record counter is less than 21, interest period details for the ccy    CAP058
      ** is incomplete, Db error.                                               CAP058
                                                                                CAP058
     C                   IF        DDACTN <> 'I'                                CAP058
     C                   IF        (*IN99 = TRUE) AND (##X < 21)                CAP058
     C                   MOVEL     'FDINTRLL'    DBFILE                         CAP058
     C                   Z-ADD     1             DBASE                          CAP058
     C                   MOVEL     DDCCY         DBKEY                          CAP058
     C                   EXSR      *PSSR                                        CAP058
     C                   ENDIF                                                  CAP058
     C                   ENDIF                                                  CAP058
      *
      * Update output borrowing and lending rates
      *
     C                   Z-ADD     @@BR(1)       FYBR01
     C                   Z-ADD     @@BR(2)       FYBR02
     C                   Z-ADD     @@BR(3)       FYBR03
     C                   Z-ADD     @@BR(4)       FYBR04
     C                   Z-ADD     @@BR(5)       FYBR05
     C                   Z-ADD     @@BR(6)       FYBR06
     C                   Z-ADD     @@BR(7)       FYBR07
     C                   Z-ADD     @@BR(8)       FYBR08
     C                   Z-ADD     @@BR(9)       FYBR09
     C                   Z-ADD     @@BR(10)      FYBR10
     C                   Z-ADD     @@BR(11)      FYBR11
     C                   Z-ADD     @@BR(12)      FYBR12
     C                   Z-ADD     @@BR(13)      FYBR13
     C                   Z-ADD     @@BR(14)      FYBR14
     C                   Z-ADD     @@BR(15)      FYBR15
     C                   Z-ADD     @@BR(16)      FYBR16
     C                   Z-ADD     @@BR(17)      FYBR17
     C                   Z-ADD     @@BR(18)      FYBR18
     C                   Z-ADD     @@BR(19)      FYBR19
     C                   Z-ADD     @@BR(20)      FYBR20
     C                   Z-ADD     @@BR(21)      FYBR21
     C                   Z-ADD     @@LR(1)       FYLR01
     C                   Z-ADD     @@LR(2)       FYLR02
     C                   Z-ADD     @@LR(3)       FYLR03
     C                   Z-ADD     @@LR(4)       FYLR04
     C                   Z-ADD     @@LR(5)       FYLR05
     C                   Z-ADD     @@LR(6)       FYLR06
     C                   Z-ADD     @@LR(7)       FYLR07
     C                   Z-ADD     @@LR(8)       FYLR08
     C                   Z-ADD     @@LR(9)       FYLR09
     C                   Z-ADD     @@LR(10)      FYLR10
     C                   Z-ADD     @@LR(11)      FYLR11
     C                   Z-ADD     @@LR(12)      FYLR12
     C                   Z-ADD     @@LR(13)      FYLR13
     C                   Z-ADD     @@LR(14)      FYLR14
     C                   Z-ADD     @@LR(15)      FYLR15
     C                   Z-ADD     @@LR(16)      FYLR16
     C                   Z-ADD     @@LR(17)      FYLR17
     C                   Z-ADD     @@LR(18)      FYLR18
     C                   Z-ADD     @@LR(19)      FYLR19
     C                   Z-ADD     @@LR(20)      FYLR20
     C                   Z-ADD     @@LR(21)      FYLR21
     C                   MOVEL     @@EX(1)       FYEX01                         CAP058
     C                   MOVEL     @@EX(2)       FYEX02                         CAP058
     C                   MOVEL     @@EX(3)       FYEX03                         CAP058
     C                   MOVEL     @@EX(4)       FYEX04                         CAP058
     C                   MOVEL     @@EX(5)       FYEX05                         CAP058
     C                   MOVEL     @@EX(6)       FYEX06                         CAP058
     C                   MOVEL     @@EX(7)       FYEX07                         CAP058
     C                   MOVEL     @@EX(8)       FYEX08                         CAP058
     C                   MOVEL     @@EX(9)       FYEX09                         CAP058
     C                   MOVEL     @@EX(10)      FYEX10                         CAP058
     C                   MOVEL     @@EX(11)      FYEX11                         CAP058
     C                   MOVEL     @@EX(12)      FYEX12                         CAP058
     C                   MOVEL     @@EX(13)      FYEX13                         CAP058
     C                   MOVEL     @@EX(14)      FYEX14                         CAP058
     C                   MOVEL     @@EX(15)      FYEX15                         CAP058
     C                   MOVEL     @@EX(16)      FYEX16                         CAP058
     C                   MOVEL     @@EX(17)      FYEX17                         CAP058
     C                   MOVEL     @@EX(18)      FYEX18                         CAP058
     C                   MOVEL     @@EX(19)      FYEX19                         CAP058
     C                   MOVEL     @@EX(20)      FYEX20                         CAP058
     C                   MOVEL     @@EX(21)      FYEX21                         CAP058
      *
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SecChk - Validation of user's action code security.
      *****************************************************************
     C     SecChk        BEGSR
      *
      * Single branching.
      *
     C     BJSBRC        IFNE      *BLANK
     C                   CALL      'ZVACTU'
     C                   PARM      'I'           ACTN              1
     C                   PARM                    @ERR              1 0
      *
      * Multibranching.
      *
     C                   ELSE
      *
      * Access default branch.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      'I'           ACTN
     C                   PARM      DBRN          ZDFB              3
     C                   PARM                    @ERR              1 0
     C                   ENDIF
      *
      * This action code invalid for user.
      *
     C     @ERR          IFEQ      1
     C                   MOVE      'N'           OKACTN
     C                   MOVE      'N'           OKCCY
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'MMA0704'     MsgIdArr(Ix)
     C                   END
      *
     C     ESecChk       ENDSR
      *
      *****************************************************************         CAP058
      /EJECT                                                                    CAP058
      *****************************************************************         CAP058
      *                                                               *         CAP058
      * SrCOMFLDS - Setup Common Fields                               *         CAP058
      *                                                               *         CAP058
      *****************************************************************         CAP058
     C     SrCOMFLDS     BEGSR                                                  CAP058
                                                                                CAP058
     C                   EVAL      FYRCID = HWRCID                              CAP058
     C                   EVAL      FYDLUP = HWDLUP                              CAP058
     C                   EVAL      FYMLUP = HWMLUP                              CAP058
     C                   EVAL      FYYLUP = HWYLUP                              CAP058
     C                   EVAL      FYTLUP = HWTLUP                              CAP058
     C                   EVAL      FYLCD = HWLCD                                CAP058
     C                   EVAL      FYLUSI = HWLUSI                              CAP058
     C                   EVAL      FYCCY = HWCCY                                CAP058
     C                   EVAL      FYDLTF = HWDLTF                              CAP058
     C                   EVAL      FYREPA = HWREPA                              CAP058
     C                   EVAL      FYTMESTMP = HWTMESTMP                        CAP058
                                                                                CAP058
     C                   ENDSR                                                  CAP058
      *****************************************************************         CAP058
      /EJECT                                                                    CAP058
      *****************************************************************         CSD006
      *                                                               *         CSD006
      * SrVFRNT - Validation for Front Office Transaction Interface   *         CSD006
      *                                                               *         CSD006
      *****************************************************************         CSD006
     C     SrVFRNT       BEGSR                                                  CSD006
                                                                                CSD006
      ** The process here is rather peculiar. The front office Id is            CSD006
      ** not maintained on Interest rate maintenance function but on            CSD006
      ** currency maintenance (SDCURRPD)                                        CSD006
      ** Therefore we do not chain on the money market file (even if            CAP058
      ** the front office id is present).                                       CAP058
      ** The rationale is first retrieve the currency code using the            CAP058
      ** MDF id (or Front office Id) then chain on the Money Market             CAP058
      ** file with the currency code as key.                                    CAP058
                                                                                CAP058
      ** Error if action code is not 'I', 'A, or 'D'                            CSDD06
                                                                                CAP058
     C                   IF        (DDACTN <> 'I') AND (DDACTN <> 'A')          CAP058
     C                             AND (DDACTN <> 'D')                          CAP058
     C                   MOVE      'N'           OKACTN                         CAP058
     C                   ADD       1             Ix                             CAP058
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                 CAP058
     C                   MOVEL     'APM0111'     MsgIdArr(Ix)                   CAP058
     C                   GOTO      ENDVFRNT                                     CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
      ** Error if Front Office Transaction Id is blank                          CAP058
                                                                                CAP058
     C     PFOTRID       IFEQ      *BLANK                                       CAP058
     C                   MOVE      'N'           OKACTN                         CAP058
     C                   ADD       1             Ix                             CAP058
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                 CAP058
     C                   MOVEL     'APM0101'     MsgIdArr(Ix)                   CAP058
     C                   GOTO      ENDVFRNT                                     CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
 
     C                   IF        CAP058 = 'Y'                                               CAP058
      ** Access Rates with Borrowing Front Office Transaction Id                              CAP058
                                                                                              CAP058
     C     PFOTRID       CHAIN     SDCURRA                                                    CAP058
                                                                                              CAP058
      ** If not found, access Rates with Lending Front Office Transaction Id                  CAP058
                                                                                              CAP058
     C                   IF        NOT %FOUND(SDCURRLA)                                       CAP058
     C     PFOTRID       CHAIN     SDCURRB                                                    CAP058
     C                   ENDIF                                                                CAP058
                                                                                              CAP058
     C* MDF Id must be present on currencies file, as either Borrow MDF ID                    CAP058
     C* or Lend MDF ID, whether this is an insert or amend                                    CAP058
     C                   IF         NOT %FOUND(SDCURRLA) AND                                  CAP058
     C                              NOT %FOUND(SDCURRLB)                                      CAP058
     C                   MOVE      'N'           OKACTN                                       CAP058
     C                   ADD       1             Ix                                           CAP058
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)                               CAP058
     C                   MOVEL     'MMA1155'     MsgIdArr(Ix)                                 CAP058
     C                   MOVEL     PFOTRID       MsgDtaArr(Ix)                                CAP058
     C                   GOTO      ENDVFRNT                                                   CAP058
     C                   ELSE                                                                 CAP058
     C                   EVAL       DDCCY = A6CYCD                                            CAP058
     C                   ENDIF                                                                CAP058
     C                   ENDIF                                                                CAP058
                                                                                              CAP058
     C     ENDVFRNT      ENDSR                                                                CAP058
     C*****************************************************************
     C* INIT - INITIALIZATION
     C*****************************************************************
     C     INIT          BEGSR
      *
      * CLEAR OUTPUTS
      *
     C                   CLEAR                   INTRFilFmt
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKCCY
      *                                                                         CAP058
      ** Check for the existence of the replacement character at the            CAP058
      ** Transaction Id level.                                                  CAP058
     C                   IF        GHSUBS <> *blank                             CAP058
     C     GHSUBS        SCAN      DDCCY         SubForTRNN        2 0          CAP058
     C                   ENDIF                                                  CAP058
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Parameters
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Currency
     C                   PARM                    DDCCY             3
      *                                                                         CAP058
      * Currency name                                                           CAP058
     C                   PARM                    DDCYNM           32            CAP058
                                                                                CAP058
      ** Front Office Id                                                        CAP058
                                                                                CAP058
     C                   PARM                    PFOTRID          20            CAP058
 
      * OUTPUTS
      *
      * (Current) MM interest rates in file format
     C                   PARM                    INTRFilFmt
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Currency code
     C                   PARM                    OKCCY             1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
                                                                                CAP058
      ** Validation workfields                                                  CAP058
                                                                                CAP058
     C                   PARM                    ValWrkFlds                     CAP058
      *
      ** Initialize program name
      *
     C                   MOVEL     'FDINTRRTV'   DBPGM
      *
      * Key Lists
      *
      ** ACCESS BANK DETAILS
      *  (database error handling done in access program)
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      *
      ** Access switchable features file - Market data feed
      *
      ** Access SAR details file to see if CAP058 is installed.                 CAP058
                                                                                CAP058
     C                   CALL      'AOSARDR0'                                   CAP058
     C                   PARM      *BLANKS       @RTCD                          CAP058
     C                   PARM      '*VERIFY'     @OPTN                          CAP058
     C                   PARM      'CAP058'      @SARD                          CAP058
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP058
                                                                                CAP058
     C                   IF        @RTCD <> *Blanks AND                         CAP058
     C                             @RTCD <> '*NRF   '                           CAP058
     C                   MOVEL     'SCSARDPD'    DBFILE                         CAP058
     C                   Z-ADD     2             DBASE                          CAP058
     C                   MOVEL     'CAP058'      DBKEY                          CAP058
     C                   EXSR      *PSSR                                        CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
     C                   IF        @RTCD = *Blanks                              CAP058
     C                   MOVEL     'Y'           CAP058            1            CAP058
     C                   ELSE                                                   CAP058
     C                   MOVEL     'N'           CAP058                         CAP058
     C                   ENDIF                                                  CAP058
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
