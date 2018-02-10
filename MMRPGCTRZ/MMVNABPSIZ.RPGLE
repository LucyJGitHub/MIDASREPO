     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate NA Purchased Parcel Size        ')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVNABPSIZ - Validate Parcel size for NA purchased           *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP002  *CREATE    Date 28Oct97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
      ** Error message field received as a parameter
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Parcel Size received as a parameter
     D DDPSZE          S              5A
 
      ** Parcel indicator received as a parameter
     D DDPCLI          S              1A
 
      ** Parcel indicator OK received as a parameter
     D DDPCLIOk        S              1A
 
      ** Face Value OK received as a parameter
     D DDFValOk        S              1A
 
      ** Face Value from Std Deal file received as a parameter
     D IHFVAL          S             15P 0
 
      ** Purchase Price from Std Deal file received as a parameter
     D IHAMNP          S             15P 0
 
      ** Purchase price OK received as a parameter
     D DDAmnpOk        S              1A
 
      ** Parcel size of related deal (5,0P)
     D IHPSZE          S              5P 0
 
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
 
      ** Position scan string found
     D Position        S              3P 0
 
      ** Decimal separator character (1A from SDDEALPD, via caller)
     D BNDCSP          S              1A
 
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
      *
      *  *----------------------*
      *  * Validate Parcel Size *
      *  *----------------------*
      *
      ** This is defined on NA purchased trade and NA sold trade. On
      ** the purchased trade it defines the number of separately
      ** saleable portions of NAB. eg. a purchase of $500,000 NA's
      ** with parcel size of 5 means that this may be sold in 1 to 5
      ** portions, the minimum amount sellable is $100,000 (where
      ** these amounts are face values).
      ** On the sale trade it determines the number of parcels/portions
      ** being sold by the transaction.
      ** During CoB processing DL0280 reduces PSZE on DEALSDE
      ** (and purchase amount, face value) to reflect the sold NA's
      ** as each sale reaches its value date.
      *
      ** Check that the input field is numeric
      ** =====================================
      ** Put the input field into the parameter field for ZA0840; set the
      ** number of decimal places to 0 and the number of integers to 5, and
      ** disable the thousands/millions function.
     C     DDPSZE        IFNE      *Blanks
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
 
      ** If the error code is zero, the field contains a valid number, but
      ** ZA0840 allows a decimal separator, which is not allowed here, so
      ** check for that.  Also an error if the number is negative.
     C     BNDCSP        SCAN      DDPSZE        Position
     C                   IF        @@ERCD <> 0
     C                               OR (@@ERCD = 0 AND Position <> 0)
     C                               OR @@AMT < 0
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMA0128'     MsgID1
     C                   ELSE
      * if it's valid, move it to the 5 packed field
     C                   Z-ADD     @@AMT         IHPSZE
     C                   MOVE      @@ALPH        DDPSZE
     C                   ENDIF
     C                   ENDIF
      *
      ** Must be non blank if parcel flag is equal to 'P' and
      ** must be numeric and greater than zero (i.e. >=1 )
     C     DDPCLI        IFEQ      'P'
      *
      ** Must be entered if Parcel flag is 'P'
     C     IHPSZE        IFLT      1
     C     Errorfound    ANDNE     'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM2002'     MSGID1
     C                   END
      *
      ** Must be ZERO (blank) if parcel flag is NOT equal to 'P'.
      *
     C                   ELSE
      *
     C     IHPSZE        IFNE      0
     C     Errorfound    ANDNE     'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM2002'     MSGID1
     C                   END
      *
     C                   END
      *
      ** Face value divided by parcel size must be greater than or
      ** equal to one unit of ccy (i.e. 1 Dollar, 1 Yen, 1 Dinar....)
      ** i.e. a parcel size is worth >= one whole unit of currency
      ** Only validate if face value is valid (*IN17), if no previous
      ** PSZE errors (*IN68), PSZE is non zero and PCLI is OK (*IN64).
     C     IHPSZE        IFGE      1
     C     DDPcliOK      ANDNE     'N'
     C     Errorfound    ANDNE     'Y'
     C     DDFvalOK      ANDNE     'N'
     C     IHFVAL        DIV       IHPSZE        @WK01            15 0
     C                   MVR                     @WK02            15 0
      *
     C     @WK02         IFNE      *ZERO
      ** Parcel is not a whole currency size (may be < or > 1)
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM2003'     MSGID1
     C                   END
     C                   END
      *
      *
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
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    DDPSZE
     C                   PARM                    DDPCLI
     C                   PARM                    DDPcliOK
     C                   PARM                    DDFvalOK
     C                   PARM                    IHFVAL
     C                   PARM                    IHAMNP
     C                   PARM                    IHPSZE
     C                   PARM                    DDAmnpOK
     C                   PARM                    BNDCSP
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
