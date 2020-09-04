     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas OF Validate Mgt Int Statements definitions')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module - Validate Int Int Stat fields *
      *                                                               *
      *  GLVACMI -  validate Interim Interest Statements fields       *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE101  *CREATE    Date 27Aug14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE101 - Interim Interest Statement on a Frequency           *
      *                                                               *
      *****************************************************************

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

      ** Array of Frequency
     D FREQ            S              1    DIM(14) CTDATA PERRCD(14)

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

     D OkACMIDs      E DS                  EXTNAME(GLEACMI1D)
      * OK Flags for fields INterim Int Statement

     D TranIn5S      E DS                  EXTNAME(GLAMMI1D)
      * Incoming Transaction - Interim Int Statement

     D VALIDMIST     E DS                  EXTNAME(GLVACMI1D)
      * Incoming Transaction - Interim Int Statement

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ =====================================¦
      ** +-------------------------------------- +

      ** External DS for Access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Define Work field for Return Code
     D W0RTN           S              7
      **

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0

      ** Parameters
     D ValidNISD       S              5  0

     D DATFIN          S              1
     D INDATE          S              5  0

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
     C                   Z-ADD     0             WIdx

      ** Validation of extension fields
      ** Validation of Indicator
     C                   EXSR      SrSTMI

      ** Validation of Date
     C                   EXSR      SrNISD

      ** Validation of Frequency
     C                   EXSR      SrISFF

      ** Validation of Day in Month
     C                   EXSR      SrISFM

      ** Return
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrSTMI - Validate Interim Int Statement Indicator             *
      *****************************************************************
     C     SrSTMI        BEGSR
      *
     C                   IF        MDSTMI <> *BLANKS AND MDSTMI <> '1' AND
     C                             MDSTMI <> '2' AND MDSTMI <> '3'
     C                   Eval      MDSTMIOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIDXAr(Idx) = '5047341'
     C                   Eval      MsgDtaXAr(Idx) = MDSTMI
     C                   Eval      FldNamXAr(Idx) = 'MDSTMI'
     C                   Eval      RetCodeIn = 'Error'
     C                   ENDIF

      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrNISD - Validate Interim Int Statement Date                  *
      *****************************************************************
     C     SrNISD        BEGSR

      * IF Next Statement Date is not entered
b1   C                   IF        MDNISD = *BLANKS

      ** Date is to be entered if Indicator is entered

b2   C                   IF        MDSTMI <> *BLANKS
     C                   Eval      MDNISDOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIDXAr(Idx) = '5047342'
     C                   Eval      MsgDtaXAr(Idx) = *BLANKS
     C                   Eval      FldNamXAr(Idx) = 'MDNISD'
     C                   Eval      RetCodeIn = 'Error'
e2   C                   ENDIF

      ** IF Next Stat. Date is entered

x1   C                   ELSE

      ** Indicator is to be entered if Date is entered

b2   C                   IF        MDSTMI = *BLANKS
     C                   Eval      MDNISDOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIDXAr(Idx) = '5047343'
     C                   Eval      MsgDtaXAr(Idx) = *BLANKS
     C                   Eval      FldNamXAr(Idx) = 'MDNISD'
     C                   Eval      RetCodeIn = 'Error'

x2   C                   ELSE
     C                   MOVEL     MDNISD        PDATPRM           6

      ** Validate Date entered

     C                   CALLB     'ZDATE1'
     C                   PARM      PDATPRM       PDateIn           6
     C                   PARM                    PDaynoOut         5 0
     C                   PARM      DATFIN        PDateFmt          1
     C                   PARM                    PError            1
      *
      ** If invalid date, issue error
      *
b3   C     PError        IFEQ      'Y'
     C                   Eval      MDNISDOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIDXAr(Idx) = '5047344'
     C                   Eval      MsgDtaXAr(Idx) = *BLANKS
     C                   Eval      FldNamXAr(Idx) = 'MDNISD'
     C                   Eval      RetCodeIn = 'Error'

x3   C                   ELSE

      ** If valid date, can not be earlier that today's date

b4   C                   IF        PDaynoOut < INDATE
b5   C                   IF        MVNISD <> PDaynoOut
     C                   Eval      MDNISDOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIDXAr(Idx) = '5047345'
     C                   Eval      MsgDtaXAr(Idx) = *BLANKS
     C                   Eval      FldNamXAr(Idx) = 'MDNISD'
     C                   Eval      RetCodeIn = 'Error'
x5   C                   ELSE

      ** If date is correct, setup output parm as midas day number

     C                   Z-ADD     PDaynoOut     ValidNISD
e5   C                   ENDIF

x4   C                   ELSE

      ** If date is correct, setup output parm as midas day number

     C                   Z-ADD     PDaynoOut     ValidNISD
e4   C                   ENDIF
e3   C                   ENDIF

e2   C                   ENDIF
e1   C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrISFF - Validate Interim Int Statement Frequency             *
      *****************************************************************
     C     SrISFF        BEGSR

      ** IF Frequency is not entered

b1   C                   IF        MDISFF = *BLANKS

      ** Freqyency is to be entered if Indicator is entered

b2   C                   IF        MDSTMI <> *BLANKS
     C                   Eval      MDISFFOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIDXAr(Idx) = '5047346'
     C                   Eval      MsgDtaXAr(Idx) = MDISFF
     C                   Eval      FldNamXAr(Idx) = 'MDISFF'
     C                   Eval      RetCodeIn = 'Error'
e2   C                   ENDIF

      ** IF Frequency is entered

x1   C                   ELSE

      ** Indicator is to be entered if Frequency is entered

b2   C                   IF        MDSTMI = *BLANKS
     C                   Eval      MDISFFOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIDXAr(Idx) = '5047347'
     C                   Eval      MsgDtaXAr(Idx) = MDISFF
     C                   Eval      FldNamXAr(Idx) = 'MDISFF'
     C                   Eval      RetCodeIn = 'Error'

x2   C                   ELSE

      ** Frequency valid values: D, W, F, S, M, T, R, B, L, A, T, Q, X, Y

     C     MDISFF        LOOKUP    FREQ                                   80
b3   C                   IF        *IN80 = '0'
     C                   Eval      MDISFFOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIDXAr(Idx) = '5047348'
     C                   Eval      MsgDtaXAr(Idx) = MDISFF
     C                   Eval      FldNamXAr(Idx) = 'MDISFF'
     C                   Eval      RetCodeIn = 'Error'
e3   C                   ENDIF

e2   C                   ENDIF
e1   C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SrISFM - Validate Interim Int Statement Day in Month          *
      *****************************************************************
     C     SrISFM        BEGSR

      ** IF Day in Month is not entered

b1   C                   IF        MDISFM = *BLANKS

      ** Day in Month is to be entered if frequency is 'M', 'T', 'Q', 'X' or 'Y'

b2   C                   IF        MDISFF = 'M' OR MDISFF = 'T' OR
     C                             MDISFF = 'Q' OR MDISFF = 'X' OR
     C                             MDISFF = 'Y'
     C                   Eval      MDISFMOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIDXAr(Idx) = '5047349'
     C                   Eval      MsgDtaXAr(Idx) = MDISFM
     C                   Eval      FldNamXAr(Idx) = 'MDISFM'
     C                   Eval      RetCodeIn = 'Error'
e2   C                   ENDIF

      ** IF Day in Month is entered

x1   C                   ELSE

      ** Frequency has to be 'M', 'T', 'Q', 'X' or 'Y'

b2   C                   IF        MDISFF <> 'M' AND MDISFF <> 'T' AND
     C                             MDISFF <> 'Q' AND MDISFF <> 'X' AND
     C                             MDISFF <> 'Y'
     C                   Eval      MDISFMOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIDXAr(Idx) = '5047350'
     C                   Eval      MsgDtaXAr(Idx) = *BLANKS
     C                   Eval      FldNamXAr(Idx) = 'MDISFM'
     C                   Eval      RetCodeIn = 'Error'

x2   C                   ELSE

      ** Day in Month must be between 1 and 31

     C                   MOVE      MDISFM        @DISFM            2 0
b3   C     @DISFM        IFLT      1
     C     @DISFM        ORGT      31
     C                   Eval      MDISFMOK = 'N'
     C                   Eval      Idx = Idx + 1
     C                   Eval      MsgIDXAr(Idx) = '5047351'
     C                   Eval      MsgDtaXAr(Idx) = MDISFM
     C                   Eval      FldNamXAr(Idx) = 'MDISFM'
     C                   Eval      RetCodeIn = 'Error'

e3   C                   ENDIF
e2   C                   ENDIF
e1   C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Other parms
      ** Field(s) requiring validation
      ** Inteim Int Statement fields
     C                   Parm                    TranIn5S
     C                   Parm                    VALIDMIST
      *
     C                   Parm                    DATFIN
     C                   Parm                    INDATE
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** OK Flags for fields
     C                   Parm                    OkACMIDs
      *
     C                   Parm                    ValidNISD         5 0


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
(c) Misys International Banking Systems Ltd. 2014
** FREQ - ARRAY For Frequency validation
DWFSMTRBLATQXY
