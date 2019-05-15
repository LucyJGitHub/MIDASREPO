     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate NA sold parcel size')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVNASSPSZ - Validate parcel size for NA sold                *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Parcel size and confirms whether it has a valid   *
      *             value.                                            *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain  'Error'             *
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
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 224627             Date 06Jun06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 28Oct97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  224627 - Truncation of the result placed in @SIZE allows     *
      *           possibility to oversell NAP causing errors.         *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** ==========
      ** Parameters
 
      ** Message ID 1 (7A, returned to caller)
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Deal file version of parcel size (5,0P, returned
      ** from this module)
     D ILPSZE          S              5P 0
 
      ** Deal file version of parcel indicator (1A, returned
      ** from this module)
     D ILPCLI          S              1A
 
      ** Parcel Size (5A, from transaction)
     D DDPSZE          S              5A
 
      ** Parcel indicator of related deal (1A, from MMDENBPP, via caller)
     D HLPCLI          S              1A
 
      ** Decimal separator character (1A from SDDEALPD, via caller)
     D BNDCSP          S              1A
 
      ** Number of assets/parcels sold (5,0P, from MMDENBPP, via caller)
     D HLNSLD          S              5P 0
 
      ** Parcel size of related deal (5,0P, from MMDENBPP, via caller)
     D HLPSZE          S              5P 0
 
      ** Face value of this deal (15,0P, caller)
     D ILFVAL          S             15P 0
 
      ** Face value of related deal (15,0P, from MMDENBPP, via caller)
     D HLFVAL          S             15P 0
 
      ** Number of decimal places in currency (1,0S from SDCURRPD, via caller)
     D A6NBDP          S              1S 0
 
      ** Face value OK flag (1A, from caller)
     D DDFVALOK        S              1A
 
      ** End of parameters
      ** =================
 
      ** =========================
      ** Parameter list for ZA0840
      ** Alpha field for numeric validation
     D @@ALPH          S             16A
 
      ** Number of decimal places field for numeric validation
     D @@IDP           S              2  0
 
      ** Number of integers field for numeric validation
     D @@IINT          S              2  0
 
      ** Millions/Thousands id (Y=function on)
     D @@MTID          S              1A
 
      ** Amount calculation field
     D @@AMT           S             15  0
 
      ** Error return code for ZA0840 module
     D @@ERCD          S              1  0
 
      ** Numeric version of spread
     D @SPRD           S             11P 7
      ** End of parameter list for ZA0840
      ** ================================
 
      ** Position scan string found
     D Position        S              3P 0
 
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
 
      ** Reset error flags & msgs to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
 
      ** This is defined on NA purchased trade and NA sold trade. On
      ** the purchased trade it defines the number of separately
      ** saleable portions of NAB. eg. a purchase of $500,000 NA's
      ** with parcel size of 5 means that this may be sold in 1 to 5
      ** portions, the minimum amount sellable is $100,000 (where
      ** these amounts are face values).
      ** On the sale trade it determines the number of parcels/portions
      ** being sold by the transaction.
      *
      ** Check that the input field is numeric
      ** =====================================
      ** Put the input field into the parameter field for ZA0840; set the
      ** number of decimal places to 0 and the number of integers to 5, and
      ** and disable the thousands/millions function.
      ** NOTE: this code has been placed here so that the converted value
      ** can be used for checking against zero in the next section; the
      ** checking of ZA0840's return code comes after that.
     C                   EVAL      @@ALPH = DDPSZE
     C                   EVAL      @@IDP = 0
     C                   EVAL      @@IINT = 5
     C                   EVAL      @@MTID = 'N'
 
     C                   CALLB     'ZA0840'
     C                   PARM                    RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
 
      **  Not allowed if related deal is not a parcel (can only
      **  sell portions of a parcelled purchase)
     C     HLPCLI        IFEQ      *BLANK
 
     C                   IF        DDPSZE <> *blank
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM2005'     MsgID1
     C                   ENDIF
 
      ** Else equal to 'P'  i.e. parcelled related deal
     C                   ELSE
 
      ** Mandatory if related deal is parcel
     C                   IF        DDPSZE = *blanks
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      MsgID1 = 'MMA0207'
     C                   ELSE
 
      ** If input, parcel size must be numeric and
      ** greater than or equal to one.
 
      ** If the error code  from ZA0840 was zero, the field contains a
      ** valid number; but ZA0840 allows a decimal separator,
      ** which is not allowed here, so check for that.  Also an error
      ** if the number is negative.
     C     BNDCSP        SCAN      DDPSZE        Position
     C                   IF        @@ERCD <> 0
     C                               OR (@@ERCD = 0 AND Position <> 0)
     C                               OR @@AMT < 0
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMA0128'     MsgID1
     C                   ENDIF
     C                   ENDIF
      *
      ** Parcel size entered + sold size must be < purchase parcel size
      ** i.e. cannot sell more parcels than originally purchased
      ** (cannot sell NA's short in Dealing.) Only
      ** validate if no validation errors so far.
      ** Note that during CoB HLPSZE on NA purchased is reduced to
      ** reflect NA sold against it. Also HLNSLD is reduced to
      ** remove NA's sold from it. This means that the following
      ** validation is correct (both HLNSLD and HLPSZE are reduced
      ** in DL0280/MM0101 by the number of parcels sold as each sale
      ** reaches its value date).
     C     ErrorFound    IFEQ      'N'
     C*****@@AMT*****    ADD       HLNSLD        @SIZE             5 0                        224627
     C     @@AMT         ADD       HLNSLD        @SIZE             6 0                        224627
      *
     C     @SIZE         IFGT      HLPSZE
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM2006'     MsgID1
     C                   ENDIF
     C                   ENDIF
      *
      ** Sale face value divided by sale parcel size must be equal
      ** to original face value divide by original parcel size
      ** i.e. the face value amount of a parcel must be same in
      ** the sale transaction as in the purchase transaction.
      ** Only validate if no PSZE validation errors so far.
      ** Can only check this if valid face value entered.
     C     ErrorFound    IFEQ      'N'
     C     DDFVALOK      ANDNE     'N'
     C     HLPCLI        ANDEQ     'P'
     C     ILFVAL        DIV(H)    @@AMT         @VAL             15 0
     C     HLFVAL        DIV(H)    HLPSZE        @OVAL            15 0
      *
      **  Find the difference between the two face value per portions
     C     @VAL          IFGT      @OVAL
     C     @VAL          SUB       @OVAL         @DIFI            15 0
     C                   ELSE
     C     @OVAL         SUB       @VAL          @DIFI
     C                   ENDIF
      *
      ** now check for appropriate ccy decimal places (A6NBDP)
      * currency decimal places = 0
     C     A6NBDP        IFEQ      0
     C     @DIFI         ANDGT     1
     C                   MOVE      'Y'           ErrorFound
     C                   ENDIF
      * currency decimal places = 1
     C     A6NBDP        IFEQ      1
     C     @DIFI         DIV(H)    10            @WK151           15 1
     C     @WK151        IFGT      1
     C                   MOVE      'Y'           ErrorFound
     C                   ENDIF
     C                   ENDIF
      * currency decimal places = 2
     C     A6NBDP        IFEQ      2
     C     @DIFI         DIV(H)    100           @WK152           15 2
     C     @WK152        IFGT      1
     C                   MOVE      'Y'           ErrorFound
     C                   ENDIF
     C                   ENDIF
      * currency decimal places = 3
     C     A6NBDP        IFEQ      3
     C     @DIFI         DIV(H)    1000          @WK153           15 3
     C     @WK153        IFGT      1
     C                   MOVE      'Y'           ErrorFound
     C                   ENDIF
     C                   ENDIF
      *
     C     ErrorFound    IFEQ      'Y'
     C                   MOVE      'N'           DDFVALOK
     C                   MOVEL     'MMM2007'     MsgID1
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Output parcel size
     C     ErrorFound    IFEQ      'N'
     C                   Z-ADD     @@AMT         ILPSZE
     C                   MOVE      HLPCLI        ILPCLI
     C                   ENDIF
 
      ** If an error was found, set the return code appropriately
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
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
 
     C     *entry        PLIST
      ** Incoming return code (10A, returned to caller)
     C                   PARM                    RetCodeIn
      ** Message ID 1 (7A, returned to caller)
     C                   PARM                    Msgid1
      ** Deal file version of parcel size (5,0P, returned
      ** from this module)
     C                   PARM                    ILPSZE
      ** Deal file version of parcel indicator (1A, returned
      ** from this module)
     C                   PARM                    ILPCLI
      ** Parcel size (5A, from transaction)
     C                   PARM                    DDPSZE
      ** Parcel indicator of related deal (1A, from MMDENBPP, via caller)
     C                   PARM                    HLPCLI
      ** Decimal separator character (1A from SDDEALPD, via caller)
     C                   PARM                    BNDCSP
      ** Number of assets/parcels sold (5,0P, from MMDENBPP, via caller)
     C                   PARM                    HLNSLD
      ** Parcel size of related deal (5,0P, from MMDENBPP, via caller)
     C                   PARM                    HLPSZE
      ** Face value of this deal (15,0P, from caller)
     C                   PARM                    ILFVAL
      ** Face value of related deal (15,0P, from MMDENBPP, via caller)
     C                   PARM                    HLFVAL
      ** Number of decimal places in currency (1,0S from SDCURRPD, via caller)
     C                   PARM                    A6NBDP
      ** Face value OK flag (1A, from caller) NOTE: CAN ALSO BE CHANGED BY
      ** THIS MODULE
     C                   PARM                    DDFVALOK
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
