     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('User Definition + Menu Items Details Retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Function ILE Module                 *
      *                                                               *
      *  SFAMUSRTV - User Definition + Menu Items Details RETRIEVE    *
      *              (WITH ACTION CODE VERSUS User Definition + Menu  *
      *               Items VALIDATION)                               *
      *                                                               *
      *  Function:  This module retrieves a User Definition + Menu    *
      *             Items from the database.As it does, it validates  *
      *             the action code and User Definition + Menu Items  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *
     FFCRREQL5  IF   E           K DISK      INFSR(*PSSR)
      * Midas FC Report Requests By User of Request
      *
     FFCRREQLC  IF   E           K DISK      INFSR(*PSSR)
     F                                       RENAME(FCRREQD0:FCRREQDX)
      * REPORT REQUESTS BY USER FOR OUTPUT
      *
     FFCPREQL4  IF   E           K DISK      INFSR(*PSSR)
      * PERIODIC REPORT REQUESTS BY REQUESTING USER
      *
     FFCPREQL5  IF   E           K DISK      INFSR(*PSSR)
     F                                       RENAME(FCPREQD0:FCPREQDX)
      * PERIODIC REPORT REQUESTS BY USER FOR OUTPUT
      *
     FMUSERL6   IF   E           K DISK      INFSR(*PSSR)
     F                                       RENAME(MUserDDF:MUserFOI)
      * Midas SF Users by Front Office ID.
     FMBRBS     IF   E           K DISK      INFSR(*PSSR)
     F                                       PREFIX(B_)
      * Valid Booking Branches by USRP
      *
     FMBROS     IF   E           K DISK      INFSR(*PSSR)
     F                                       PREFIX(O_)
      * Valid Originating Branches by USRP
      *
     FMCMPS     IF   E           K DISK      INFSR(*PSSR)
     F                                       PREFIX(C_)
      * Valid Companies by USRP
      *
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
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
 
     D DepotSn         S             10    DIM(10)
      ** Depot shortnames array
 
     D DepotNo         S              6    DIM(10)
      ** Depot customer numbers array
 
     D CHK             S              1    DIM(10)
      * User Array
     D VALI            S              1    DIM(41) CTDATA PERRCD(41)
      * Array for Valid Characters for User Profile
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details ICD retrieval
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for Securities ICD Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
      * Current User Defn + Menu Items in File Format
     D AMUSFilFmt    E DS                  EXTNAME(MUSERDD)
     D                                     PREFIX(U1)
      * Current Booking Branches in File Format
     D BBRCFilFmt    E DS                  EXTNAME(MBRBSDD)
     D                                     PREFIX(B_)
      * Current Originating Branches in File Format
     D OBRCFilFmt    E DS                  EXTNAME(MBROSDD)
     D                                     PREFIX(O_)
      * Current Companies in File Format
     D COMPFilFmt    E DS                  EXTNAME(MCMPSDD)
     D                                     PREFIX(C_)
      *
      *
      * User DS for incoming Data from Access Object
     D SFUSER        E DS                  EXTNAME(MUSERDD)
      *
      ** Transaction Details in File Format
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D ZMUSER          DS
     D  USRID                  1     10
     D  DBRNZ                 11     13
     D  DPPTZ                 14     16
     D  BANKZ                 17     17
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
      * Index for User Array
     D CIx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      * Initialisation
     C                   EXSR      INIT
      *
      * If the mode is 'Front Office Transaction Interface'
      * Do (Extra) Validation for Front Office Transaction Interface
     C                   IF        ModeofOp = '*FRONT'
     C                   EXSR      VFRNT
      *
      **  Carry out no further validation if errors have occurred.
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      * Validate Action Code & Transaction Number
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
     C                   IF        OKACTN = 'N' OR
     C                             OKUSRP = 'N'
     C                   RETURN
     C                   ENDIF
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
     C                   IF        RespMode = 'S'
     C                   EVAL      ZACTN=DDACTN
      *
      ** If single branching
      ** Access Security Checking - Single Branching
     C                   IF        BJSBRC <> *BLANK AND
     C                             RESPMODE = 'S'
     C                   EXSR      ACSSES
     C                   ENDIF
      *
      ** If multibranching
      ** Access Security Checking - Multi-Branching
     C                   IF        BJSBRC = *BLANK AND
     C                             DDACTN <> 'I' AND
     C                             RESPMODE = 'S'
     C                   EXSR      ACSSEM
     C                   ENDIF
     C                   ENDIF
      *
      **  Carry out no further validation if errors have occurred.
     C                   IF        OKACTN = 'N'
     C                   RETURN
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'I' *
      *  *--------------------------------*
     C                   IF        DDACTN = 'I'
     C                   EXSR      VALACI
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
     C                   IF        DDACTN = 'E'
     C                   EXSR      RTVAMUS
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
     C                   IF        DDACTN = 'A'
     C                   EXSR      RTVAMUS
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'D' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'D'
     C                   EXSR      RTVAMUS
     C                   EXSR      VALACD
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'R' *
      *  *--------------------------------*
      *
     C                   IF        DDACTN = 'R'
     C                   EXSR      RTVAMUS
     C                   EXSR      VALACR
     C                   ENDIF
      *
      **  Carry out no further validation if errors occurred.
     C                   IF        OKACTN = 'N' OR
     C                             OKUSRP = 'N'
     C                   RETURN
     C                   ENDIF
 
      * Return
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSES - ACCESS SECURITY CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSES        BEGSR
      *
      **  Check user's authority for the action.
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN             1
     C                   PARM                    ERR               1 0
      *
      **  If action invalid for user
     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ACSSEM - ACCESS SECURITY CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSEM        BEGSR
      *
      **  Check user's authority for the action & Booking Branch.
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN             1
     C                   PARM      DBRNZ         ZBR               3
     C                   PARM                    ERR               1 0
      *
      **   If action invalid for user
     C                   IF        ERR = 1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'RE71070'     MsgIdArr(Ix)
     C                   ELSE
     C                   IF        ERR = 2
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='I'
     C                   MOVEL     'RE7102B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='D'
     C                   MOVEL     'RE7104B'     MsgIdArr(Ix)
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      **************************************************************************
      * RTVAMUS - RETRIEVE User Definition + Menu Items DETAILS IF ACTION CODE
      * 'A', 'E', 'R' OR 'D'
      **************************************************************************
     C     RTVAMUS       BEGSR
 
      * Access User from the User file
      *
      ** CHECK THAT THIS USER EXISTS ON LF/MUSER VIA ACCESS PROGRAM
      *
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANK        @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM                    DDUSRP
     C     SFUSER        PARM      SFUSER        DSSDY
      *
      ** IF ACCESS PROGRAM ENDS IN ERROR.
      * Transaction details not found
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0406'
     C                   GOTO      ENDRTV
     C                   ELSE
     C                   EVAL      AMUSFilFmt = SFUSER
     C                   ENDIF
      *
      * Access Valid Booking Branches from MBRBS File
      *
     C     DDUSRP        CHAIN     MBRBS                              99
     C                   IF        *IN99 = *ON
     C                   EVAL      BBRCFilFmt = *BLANKS
     C                   ENDIF
      *
      * Access Valid Originating Branches from MBROS File
      *
     C     DDUSRP        CHAIN     MBROS                              99
     C                   IF        *IN99 = *ON
     C                   EVAL      OBRCFilFmt = *BLANKS
     C                   ENDIF
      *
      * Access Valid Companies from MCMPS File
      *
     C     DDUSRP        CHAIN     MCMPS                              99
     C                   IF        *IN99 = *ON
     C                   EVAL      COMPFilFmt = *BLANKS
     C                   ENDIF
      *
     C     EndRTV        ENDSR
      ************************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      * ERROR IF ACTION CODE IS NOT 'I','A','E','R' OR 'D'
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C                             DDACTN <> 'D' AND
     C                             DDACTN <> 'R'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   EVAL      MsgIdArr(Ix) = 'SFM0448'
     C                   ENDIF
      *
      * Error if Front Office Transaction ID is Blank
     C                   IF        FOTRID = *BLANK
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0201'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
      * Access Transaction with Front Office Transaction ID
     C     FOTRID        CHAIN     MUSERFOI                           99
      *
      * If Insert
      *
     C                   IF        DDACTN = 'I'
      *
      * Front Office Transaction ID can't be Present already
     C                   IF        *IN99 = *OFF
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0202'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ELSE
      *
      * If not insert, Front Office Transaction ID Must be Present
     C                   IF        *IN99 = *ON
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0203'     MsgIdArr(Ix)
     C                   MOVEL     FOTRID        MsgDtaArr(Ix)
     C                   GOTO      EVFRNT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND USER
      *****************************************************************
     C     VAL           BEGSR
 
      * Action Code
      *  .. must be 'I','A','D','E' or 'R'
     C                   IF        DDACTN <> 'I' AND
     C                             DDACTN <> 'A' AND
     C                             DDACTN <> 'E' AND
     C                             DDACTN <> 'D' AND
     C                             DDACTN <> 'R'
     C                   EVAL      OKACTN = 'N'
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   EVAL      MsgIdArr(Ix) = 'SFM0448'
     C                   ENDIF
      *  User is required
     C                   IF        DDUSRP = *BLANKS
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0449'
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ** Check User must be Left Adjusted ( with no embedded blanks)
      *
     C                   MOVEL     DDUSRP        CHEK01            1
     C     CHEK01        IFEQ      ' '
     C     CHEK01        ORGT      'Z'
     C     CHEK01        ORLT      'A'
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0450'
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ** USER PROFILE MUST HAVE NO EMBEDDED BLANKS.
      *
     C                   MOVEA     DDUSRP        CHK
     C                   Z-ADD     1             CIx
     C                   MOVE      '0'           *IN40
     C     CIx           DOWLE     10
      *
     C                   MOVE      '0'           *IN90
     C     CHK(CIx)      LOOKUP    VALI                                   90
     C     CHK(CIx)      IFNE      ' '
      *
     C     *IN40         IFEQ      '1'
     C     *IN90         OREQ      '0'
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0450'
     C                   GOTO      EVAL
     C                   Z-ADD     10            CIx
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      '1'           *IN40
     C                   ENDIF
      *
     C                   ADD       1             CIx
     C                   ENDDO
      *
 
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACI - VALIDATION OF ACTION CODE 'I'
      *****************************************************************
     C     VALACI        BEGSR
 
      *
      * Access User from the MUSR file
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANK        @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM                    DDUSRP
     C     SFUSER        PARM      SFUSER        DSSDY
      *
      * User details found
      *
     C     @RTCD         IFEQ      *BLANK
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0451'
      *
     C                   IF        RECI = 'C'
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0435'
     C                   ELSE
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0436'
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      *
     C     EVALAI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACD - VALIDATION OF ACTION CODE 'D'
      *****************************************************************
     C     VALACD        BEGSR
 
      *
      ** User must Exists
      *
      * Access User from the MUSR file
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANK        @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM                    DDUSRP
     C     SFUSER        PARM      SFUSER        DSSDY
      *
      * User details not found
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0437'
     C                   GOTO      EVALAD
      *
     C                   ELSE
      *
     C                   IF        RECI = 'C'
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0437'
     C                   GOTO      EVALAD
     C                   ENDIF
     C                   EVAL      AMUSFilFmt = SFUSER
      *
     C                   ENDIF
      *
      ** IF DELETING, ENSURE USER DOESN'T HAVE SUICIDAL TENDENCIES.
      * i.e same as ZMUSER User(USRID)
     C                   IF        DDUSRP = USRID
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0438'
     C                   ENDIF
      *
      ** If deleting user is being maintained by another wrkstn,
      ** do not allow deletion
      * Access ZMUSER User USRID from the MUSR file
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANK        @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM                    USRID
     C     SFUSER        PARM      SFUSER        DSSDY
      *
      * ZMUSER User USRID Error
      *
     C     @RTCD         IFEQ      '*ERROR'
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0439'
     C                   GOTO      EVALAD
     C                   ENDIF
      *
      *
      ** NOT AUTHORISED TO DELETE A USER WITH A HIGHER SECURITY LEVEL
      * i.e ZMUSER User Sec.LVL from MUSER is less than Screen I/p SLVL
      *
     C                   MOVE      DDSECL        SSECN             4 0
      *
     C                   IF        SECL < SSECN
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0440'
     C                   GOTO      EVALAD
     C                   ENDIF
      *
      ** Cannot delete MIDAS user
      *
     C     DDUSRP        IFEQ      'MIDAS   '
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0441'
     C                   GOTO      EVALAD
     C                   ENDIF
      *
      ** Cannot delete user who has report requests outstanding
      *
     C     DDUSRP        CHAIN     FCRREQL5                           88
     C     *IN88         IFEQ      '0'
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0442'
     C                   GOTO      EVALAD
     C                   ENDIF
      *
      ** Cannot delete user who is defined as user for output
      *
     C     DDUSRP        CHAIN     FCRREQLC                           88
     C     *IN88         IFEQ      '0'
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0443'
     C                   GOTO      EVALAD
     C                   ENDIF
      *
      ** Cannot delete user who is defined as requesting user for
      ** periodic reports
      *
     C     DDUSRP        CHAIN     FCPREQL4                           88
     C     *IN88         IFEQ      '0'
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0444'
     C                   GOTO      EVALAD
     C                   ENDIF
      *
      ** Cannot delete user who is defined as user for output on
      ** periodic reports
      *
     C     DDUSRP        CHAIN     FCPREQL5                           88
     C     *IN88         IFEQ      '0'
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0445'
     C                   GOTO      EVALAD
     C                   ENDIF
      *
 
     C     EVALAD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALACR - VALIDATION OF ACTION CODE 'R'
      *****************************************************************
     C     VALACR        BEGSR
      *
      ** REACTIVATE must refer to a Deleted (Reci = 'C') record on File.
      *
     C     DDACTN        IFEQ      'R'
      * Access User from the MUSR file
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANK        @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM                    DDUSRP
     C     SFUSER        PARM      SFUSER        DSSDY
      *
      * User details not found
      *
     C     @RTCD         IFNE      *BLANK
     C     RECI          OREQ      'D'
     C                   EVAL      OKUSRP = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNameArr(Ix) = 'DDUSRP'
     C                   EVAL      MsgIdArr(Ix) = 'SFM0446'
     C                   GOTO      EVALAR
     C                   ELSE
     C                   EVAL      AMUSFilFmt = SFUSER
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EVALAR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initial processing
      *****************************************************************
     C     INIT          BEGSR
 
      * Clear Outputs
     C                   CLEAR                   AMUSFilFmt
     C                   CLEAR                   BBRCFilFmt
     C                   CLEAR                   OBRCFilFmt
     C                   CLEAR                   COMPFilFmt
     C                   EVAL      OKACTN = 'Y'
     C                   EVAL      OKUSRP = 'Y'
 
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initialisation
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Parameters
     C     *ENTRY        PLIST
 
      * Inputs
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * (Midas) SF User Profile
     C                   PARM                    DDUSRP           10
      * User Security Level
     C                   PARM                    DDSECL            4
      *
      * Outputs
      *
      * User Definition + Menu Items Details in File Format
     C                   PARM                    AMUSFilFmt
      * Booking Branches Details in File Format
     C                   PARM                    BBRCFilFmt
      * Originating Branches Details in File Format
     C                   PARM                    OBRCFilFmt
      * Companies Details in File Format
     C                   PARM                    COMPFilFmt
      *
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - (Midas) SF User Profile
     C                   PARM                    OKUSRP            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ** Initialise program name
     C                   EVAL      DBPGM = 'SFAMUSRTV'
      *
      **  GET RUNDAT to access MULTI-BRANCHING flag.
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'                           ************
     C                   EVAL      DBASE  = 900                                  * DBERR 900*
     C                   EVAL      DBKEY = @OPTN                                 ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
 
      ** Note: if non-standard processing required, use the PSSR_ILENE*
      ** subroutine                                                   *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
** TABLE - VALI
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789#$_-@
