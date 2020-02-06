     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Customer Shortname')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVCCSH  - Validate Customer Shortname                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD030956           Date 09Oct14               *
      *                 MD025994           Date 19Aug14               *
      *                 MD025238           Date 28Feb14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249029             Date 11Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11873           Date 12Aug06               *
      *                 CSD027             Date 05Jan06               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4653            Date 27Oct04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034   *CREATE   Date 01Apr99               *
      *                                    Date ddmmmyy               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  MD025994 - Event code substring substitution not happening   *
      *             for error USR0505. Fix patterned to MD000091.     *
      *  MD025238 - Shortname cannot begin with numeric value         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249029 - Do not allow same CNUM and shortname for the same   *
      *           customer.                                           *
      *  BUG11873 - Prompting cust short name must begin with alpha   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4653 - Can insert more than one customer with             *
      *            the same shortname into WIP state.                 *
      *  CAP034 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
      *                                                               *
      *****************************************************************
 
      * Midas SD Customer Details
     FSDCUSTL1  IF   E           K DISK
     F                                     RENAME(@BBREBF:CUSTDETAIL)
      *
      ** Midas SD Customer Details by Shortname
     FSDCUSTL6  IF   E           K DISK
     F                                     RENAME(@CUSTF3:CUSSNAM)
                                                                                             BUG4653
      ** Midas SD Customer Shadow Details by Shortname                                       BUG4653
     FSDCDSHL2  IF   E           K DISK                                                      BUG4653
     F                                     RENAME(@BBREBF:CDSHDETAIL)                        BUG4653
     F                                     PREFIX(SH_)                                       BUG4653
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                            MD025994
      ** Event code substring substitution                                                  MD025994
     D BChar           DS                                                                   MD025994
     D   BLen                  1      2B 0                                                  MD025994
     D   LenStr                1      2                                                     MD025994
 
      ** AlphaNumeric array for shortname check                                             MD025238
     D AlphaNum        S              1    DIM(36) CTDATA PERRCD(36)                        MD025238
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
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      *
      ** VALIDATION
      *
     C                   EXSR      CSSNV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCSSNOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C     DDDRCSOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C     DDLCCDOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION - Customer Shortname
      *****************************************************************
     C     CSSNV         BEGSR
 
      * If module Use DRS shortnames is ON
     C     BGUDRS        IFEQ      'Y'
     C                   MOVE      *BLANK        DDCSSN
     C                   MOVEL     DDDRCS        DDCSSN
     C                   MOVE      DDLCCD        DDCSSN
 
      * DRS shortname must be entered
     C     DDDRCS        IFEQ      *BLANK
     C                   MOVE      'N'           DDDRCSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDRCS'      FldNamXAr(Idx)
     C                   MOVEL     'USR0193'     MsgIdXAr(Idx)
 
     C                   ELSE
 
      * DRS shortname must begin with alpha character
     C                   MOVE      *BLANK        ALPHATEST         1
     C                   MOVEL     DDDRCS        ALPHATEST
     C     ALPHATEST     IFLT      'A'
     C     ALPHATEST     ORGT      'Z'
                                                                                            BUG11873
     C     ALPHATEST     IFGE      'a'                                                      BUG11873
     C     ALPHATEST     ANDLE     'z'                                                      BUG11873
     C                   ELSE                                                               BUG11873
     C                   MOVE      'N'           DDDRCSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDRCS'      FldNamXAr(Idx)
     C                   MOVEL     'USR0190'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   ENDIF                                                              BUG11873
 
     C                   ENDIF
 
      * Location code must be entered
     C     DDLCCD        IFEQ      *BLANK
     C                   MOVE      'N'           DDLCCDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLCCD'      FldNamXAr(Idx)
     C                   MOVEL     'USR0192'     MsgIdXAr(Idx)
     C                   ENDIF
 
      * Otherwise (i.e. use DRS shortnames is OFF)
     C                   ELSE
 
     C                   MOVE      *BLANK        DDDRCS
     C                   MOVE      *BLANK        DDLCCD
 
      * Shortname must be entered
     C     DDCSSN        IFEQ      *BLANK
     C                   MOVE      'N'           DDCSSNOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCSSN'      FldNamXAr(Idx)
     C                   MOVEL     'USR0991'     MsgIdXAr(Idx)
 
     C                   ELSE
 
      **Shortname*must*begin*with*alpha*character*********************                      MD025238
     C                   MOVE      *BLANK        ALPHATEST
     C                   MOVEL     DDCSSN        ALPHATEST
     C*****ALPHATEST     IFLT      'A'                                                      MD025238
     C*****ALPHATEST     ORGT      'Z'                                                      MD025238
                                                                                            BUG11873
     C*****ALPHATEST     IFGE      'a'                                             BUG11873 MD025238
     C*****ALPHATEST     ANDLE     'z'                                             BUG11873 MD025238
     C**********         ELSE                                                      BUG11873 MD025238
      * Shortname must begin with alphanumeric value                                        MD025238
     C                   IF        %LOOKUP(ALPHATEST:AlphaNum) = 0                          MD025238
     C                   MOVE      'N'           DDCSSNOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCSSN'      FldNamXAr(Idx)
     C**********         MOVEL     'USR0832'     MsgIdXAr(Idx)                              MD025238
     C                   MOVEL     'USR0190'     MsgIdXAr(Idx)                              MD025238
     C                   ENDIF
     C**********         ENDIF                                                     BUG11873 MD025238
 
     C                   ENDIF
 
     C                   ENDIF
 
      * Check for Customer#                                                                   CSD027
     C                   If        %Subst(DDCSSN:1:6) <> *BLANKS And                          CSD027
     C                             %Subst(DDCSSN:7:4) = *BLANKS                               CSD027
     C                   Movel     DDCSSN        WCSSN             6                          CSD027
     C     WCSSN         Chain     SDCUSTL1                                                   CSD027
      * If record found & Customer# not matching                                              CSD027
     C                   If        %Found(SDCUSTL1) And                                       CSD027
     C                             BBCUST <> DDCUSN                                           CSD027
     C                   Eval      DDCSSNOK = 'N'                                             CSD027
     C                   Add       1             Idx                                          CSD027
     C                   Eval      FldNamXAr(Idx) = 'DDCSSN'                                  CSD027
     C                   Eval      MsgIdXAr(Idx) = 'S270006'                                  CSD027
     C                   EndIf                                                                CSD027
      *                                                                                       249029
     C                   If        DDCSSN = DDCUSN                                            249029
     C                   Eval      DDCSSNOK = 'N'                                             249029
     C                   Add       1             Idx                                          249029
     C                   Eval      FldNamXAr(Idx) = 'DDCSSN'                                  249029
     C                   Eval      MsgIdXAr(Idx) = 'S270014'                                  249029
     C                   EndIf                                                                249029
      *                                                                                       249029
     C                   EndIf                                                                CSD027
 
      * Find customer by shortname on file
     C                   MOVE      *BLANKS       SAMECUST
     C     DDCSSN        IFNE      *BLANKS
     C     DDCSSN        CHAIN     CUSSNAM                            90
     C     *IN90         IFEQ      '0'
 
      * note if customer number in validation differs from that on file
     C     BBCUST        IFNE      DDCUSN
     C                   MOVE      'N'           SAMECUST          1
     C                   ENDIF
     C                   ENDIF
 
      * if customer numbers differ, send error message
     C     SAMECUST      IFEQ      'N'
     C     BGUDRS        IFEQ      'Y'
     C                   MOVE      'N'           DDDRCSOK
     C                   MOVE      'N'           DDLCCDOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDRCS'      FldNamXAr(Idx)
     C                   MOVEL     'USR1067'     MsgIdXAr(Idx)
 
     C                   ELSE
 
     C                   MOVE      'N'           DDCSSNOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCSSN'      FldNamXAr(Idx)
     C                   MOVEL     'USR0505'     MsgIdXAr(Idx)
     C                   EVAL      BLen = %Len(%Trim(DDCSSN))                               MD025994
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDCSSN)                   MD025994
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      * Find customer by shortname on shadow file                                            BUG4653
     C                   MOVE      *BLANKS       SAMECUST                                    BUG4653
     C     DDCSSN        IFNE      *BLANKS                                                   BUG4653
     C     DDCSSN        CHAIN     CDSHDETAIL                         90                     BUG4653
     C     *IN90         IFEQ      '0'                                                       BUG4653
                                                                                             BUG4653
      * note if customer number in validation differs from that on file                      BUG4653
     C     SH_BBCUST     IFNE      DDCUSN                                                    BUG4653
     C                   MOVE      'N'           SAMECUST          1                         BUG4653
     C                   ENDIF                                                               BUG4653
     C                   ENDIF                                                               BUG4653
                                                                                             BUG4653
      * if customer numbers differ, send error message                                       BUG4653
     C     SAMECUST      IFEQ      'N'                                                       BUG4653
     C     BGUDRS        IFEQ      'Y'                                                       BUG4653
     C                   MOVE      'N'           DDDRCSOK                                    BUG4653
     C                   MOVE      'N'           DDLCCDOK                                    BUG4653
     C                   ADD       1             Idx                                         BUG4653
     C                   MOVEL     'DDDRCS'      FldNamXAr(Idx)                              BUG4653
     C                   MOVEL     'USR1067'     MsgIdXAr(Idx)                               BUG4653
                                                                                             BUG4653
     C                   ELSE                                                                BUG4653
                                                                                             BUG4653
     C                   MOVE      'N'           DDCSSNOK                                    BUG4653
     C                   ADD       1             Idx                                         BUG4653
     C                   MOVEL     'DDCSSN'      FldNamXAr(Idx)                              BUG4653
     C                   MOVEL     'USR0505'     MsgIdXAr(Idx)                               BUG4653
     C                   EVAL      BLen = %Len(%Trim(DDCSSN))                               MD025994
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDCSSN)                   MD025994
     C                   ENDIF                                                               BUG4653
                                                                                             BUG4653
     C                   ENDIF                                                               BUG4653
                                                                                             BUG4653
     C                   ENDIF                                                               BUG4653
 
 
 
      * If customer is on file
      * action is amend
      * module Trade Innovation is ON
      * this is a Trade innovation customer
      * AND user is attempting to change shortname - error
     C     DDCUSN        CHAIN     CUSTDETAIL                         90
     C     DDACTN        IFEQ      'A'
     C     BGN3ST        ANDEQ     'Y'
     C     BBTICS        ANDEQ     'Y'
     C     DDCSSN        ANDNE     BBCSSN
     C     DDACTN        OREQ      'A'                                                      MD030956
     C     CTI006        ANDEQ     'Y'                                                      MD030956
     C     BBTICS        ANDEQ     'Y'                                                      MD030956
     C     DDCSSN        ANDNE     BBCSSN                                                   MD030956
     C                   ADD       1             Idx
     C                   MOVEL     'USR3553'     MsgIdXAr(Idx)
 
 
     C     BGUDRS        IFEQ      'Y'
     C                   MOVE      'N'           DDDRCSOK
     C                   MOVE      'N'           DDLCCDOK
     C                   MOVEL     'DDDRCS'      FldNamXAr(Idx)
 
     C                   ELSE
 
     C                   MOVE      'N'           DDCSSNOK
     C                   MOVEL     'DDCSSN'      FldNamXAr(Idx)
     C                   ENDIF
 
      * Restore file shortname to screen field(s)
     C                   MOVE      *BLANKS       DDCSSN
     C                   MOVE      BBCSSN        DDCSSN
 
     C     BGUDRS        IFEQ      'Y'
     C                   MOVE      *BLANKS       DDDRCS
     C                   MOVE      *BLANKS       DDLCCD
     C                   MOVEL     BBCSSN        DDDRCS
     C                   MOVE      BBCSSN        DDLCCD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      * Action Code (1A)
      ** Use DRS Shortnames (1A)
      ** Trade Innovation (1A)
      ** DRS Customer Shortname (7A)
      ** Location Code (3A)
      ** Customer Shortname (10A)
      ** Customer Number (6A)
      *
     C                   PARM                    DDACTN            1
     C                   PARM                    BGUDRS            1
     C                   PARM                    BGN3ST            1
     C                   PARM                    DDDRCS            7
     C                   PARM                    DDLCCD            3
     C                   PARM                    DDCSSN           10
     C                   PARM                    DDCUSN            6
     C                   PARM                    CTI006            1                        MD030956
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Customer Shortname - OK
     C                   PARM                    DDCSSNOK          1
      *
      ** DRS Customer Shortname - OK
     C                   PARM                    DDDRCSOK          1
      *
      ** Location Code - OK
     C                   PARM                    DDLCCDOK          1
      *
      * Initialise same customer flag
      *
     C                   MOVE      *BLANK        SAMECUST
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  AlphaNum
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
