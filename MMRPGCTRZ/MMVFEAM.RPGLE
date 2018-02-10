     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Fee Amount and Currency')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVFEAM   - MM Repo Header Fee Amount and Currency Validation*
      *                                                               *
      *  Function: This Program Validates the Fee amount and          *
      *            currency                                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 1JUne99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE006 - Repurchase Agreements.                              *
      *                                                               *
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      **--------------------------------------------------------------------------------------------
 
     D ValidRepo     E DS                  EXTNAME(MMVRPDHPD)
      * Valid Repo Delivery Details
 
     D TranIn        E DS                  EXTNAME(MMRPDHPD)
     D                                     PREFIX(IK:2)
     D QQACCN1       E                     EXTFLD(QQACCN)                                     CGL029
      * Incoming Transaction
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
 
      ** Error message substitution data received as a parameter
     D MSGDATA         S                   LIKE(#MsgData)
     D MSGDATA2        S                   LIKE(#MsgData)
     D MSGDATA3        S                   LIKE(#MsgData)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D**  Currency details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for Access Programs
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** Numeric Input (also the output)
     D   ZFIELD        S             16A
     D   ZFLD15        S             15  0
 
      ** Number of decimal position
     D   ZADEC         S              1P 0
 
      * contains required number of digits before the decimal point as
      * a constant in program.
     D ZADIG           S              2P 0
 
      * returns 'Y' or 'N' depending on whether validation has been successful
     D ZALIGNok        S              1A
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
     C
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msg1
     C                   RESET                   Msg2
     C                   RESET                   Msg3
     C                   RESET                   Msg4
     C                   RESET                   IFFEAM
     C                   RESET                   IFFECY
      *
      ** If Fee amount, settlement method or account have been entered
      ** then Fee currency should be entered.
      *
     C                   IF        IKFECY = *Blanks and IKFESM <> *Blanks or
     C                             IKFECY = *Blanks and IKFEAM <> *Blanks or
     C                             IKFECY = *Blanks and IKACCN <> *Blanks
      *
     C                   MOVE      'MMA0767'     MSG2
     C                   MOVE      'Y'           ErrorFound        1
     C
     C                   ELSE
     C*
     C* Validate Currency if it is not blank
     C*
     C                   IF        IKFECY <> *Blanks
     C*
     C* Access Currency details via Access Object
     C*
     C                   CALLB     'AOCURRR0'
     C                   PARM      '       '     @@RTCD            7
     C                   PARM      '*KEY   '     @@OPTN            7
     C                   PARM      IKFECY        @@AJCD            3
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C* Send Error Message if currency is invalid
     C*
     C                   IF        @@RTCD <> *BLANKS
     C                   MOVE      'MMA0767'     MSG2
     C                   MOVE      'Y'           ErrorFound        1
     C                   ELSE
     C*
     C* Send Error Message if Fee amount is Blank
     C*
     C                   IF        IKFEAM = *BLANKS
     C                   MOVE      'MMA0768'     MSG3
     C                   MOVE      'Y'           ErrorFound        1
     C
     C                   ELSE
     C*
     C* Check that fee amount is entered in a valid format
     C*
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      IKFEAM        ZFIELD
     C                   MOVE      A6NBDP        ZADEC
     C     13            SUB       A6NBDP        ZADIG
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
     C
     C                   IF        ZALIGNok <> 'Y'
     C                   MOVE      'MMA0766'     MSG1
     C                   MOVE      'Y'           ErrorFound        1
     C
     C                   ELSE
     C
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      ZFIELD        ZFLD15
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      ZOUT21        IKFEAM
     C                   MOVE      ZFIELD        IFFEAM
     C                   MOVE      IKFECY        IFFECY
     C
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
 
     C** Set Fee amount to zero if no charge is entered
     C                   Z-ADD     0             IFFEAM
     C                   ENDIF
     C                   ENDIF
     C
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      ReturnCode = 'Error'
     C                   ENDIF
      *
     C                   RETURN
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    MSG4
      * Receive Screen Format
     C                   PARM                    TranIn
      * Receive File Format
     C                   PARM                    ValidRepo
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMEXCR'      DBPGM
     C                   OUT       LDA
      *
     C                   ENDSR
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
