     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Originating Branch')
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange Dealing Module                      *
      *                                                               *
      *  MMVBBBBRCD - MM Validate Booking Branch and default with     *
      *               Counterparty Branch                             *
      *                                                               *
      *  Function:  This module defaults the booking and originating  *
      *             branches to the branch of the counterparty of     *
      *             the transaction                                   *
      *                                                               *
      *  (C) Copyright Midas-Kapiti International Ltd. 2006           *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL058 *CREATE     Date 30Jun06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL058 - Default Branch Code                                 *
      *                                                               *
      *****************************************************************
      *
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
      *
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      *
      ** Include standard declarations
      *
     D/COPY ZACPYSRC,STDDECLARE
 
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
 
     D/COPY ZACPYSRC,PSDS
 
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
 
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      *
      ** The maximum size of the appended error arrays
      *
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      *
      ** Array of Fields in error.
      *
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      *
      ** Array of error message IDs
      *
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      *
      ** Array of error message data.
      *
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
 
     D RelDealDts      DS           100
      *
      ** Related Deal Details (when deal is option takedown or swap.
      ** Thus related deal will be other leg of swap or option).
      *
     D  RelDBRC                1      3
 
 
      *
      ** External data structure for branch codes file
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      *
      ** External data structure for access programs (short)
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
 
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
 
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
 
      *
      ** Index for arrays of error message ids etc
      *
     D Idx             S              3P 0
     D @KEY            S             10
     D @KEYSTS         S              7
 
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
 
      *
      ** Check if defaulting is to apply
      *
     C                   IF        BJSBRC = *BLANKS AND DDACTN = 'I'
     C                             AND DDCUST <> *BLANKS
      *
      ** Only default if originating branch not entered
      *
     C                   IF        BKOBRU = 'Y' AND DDORBR = *BLANKS
     C                             OR BKOBRU = 'Y' AND DDORBR = BRC
      *
      ** Retrieve branch of the counterparty by calling AOCUSTR0
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCUST        @KEY
     C                   PARM      *BLANKS       @KEYSTS
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        @RTCD  = *BLANKS
      *
     C                   EVAL      DDORBR = BBBRCD
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
      ** Return Code
      *
     C                   PARM                    DDACTN            1            Action Code
     C                   PARM                    BJSBRC            3            Single Banch
     C                   PARM                    DDCUST           10            Counterparty
     C                   PARM                    DDORBR            3            origin. branch
      *
      ** GET ZMUSER to access default branch.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
 
     C                   CALL      'AOGELRR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(C) Copyright Midas-Kapiti International Ltd. 2006
