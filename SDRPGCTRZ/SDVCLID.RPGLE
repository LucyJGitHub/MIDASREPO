     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Clearing identification')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVCLID - Validate Clearing identification                   *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD022862           Date 17Oct13               *
      *                 CFT050  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD022862 - LEI Code not accepted eventhough consists of first*
      *             18 uppercase character and last 2 numbers.        *
      *  CFT050 - SWIFTRef Directories upload                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      ** External data structure for Country Codes
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Input fields passed to ME9940
 
     D I#PARM          DS           512
      ** Field to be validated
     D  I#VFLD                 1      5
      ** Pay/Receive Settlement (PAY/REC)
     D  I#PR                   6      8
      ** Customer/Counterparty Nostro /BIC indentified type
     D  I#PRTT                 9      9
      ** Customer/Counterparty/BIC indentified
     D  I#PRTY                10     20
      ** Pay Currency
     D  I#PCCY                21     23
      ** Receive Currency
     D  I#RCCY                24     26
      ** Account Line
     D  I#ACLN                27     61
      ** Account Line Character 1
     D  I#ACC1                27     27
      ** Account Line Character 2
     D  I#ACC2                28     28
      ** Account Line Character 3
     D  I#ACC3                29     29
      ** Account Line first 4 characters
     D  I#ACCL                27     30
      ** Account Line Clearing System
     D  I#ACCS                29     30
      ** Account Line No account data
     D  I#SPC1                31     61
      ** Message Type
     D  I#MTYP                62     64
      ** Intermediary Institution for Bank to Bank validation
     D  I#INBT                65     65
     D  I#INBK                66     76
      ** Account with Institution for Bank to Bank validation
     D  I#AWBT                77     77
     D  I#AWBK                78     88
      ** Beneficiary for Bank to Bank validation
     D  I#BENT                89     89
     D  I#BENF                90    100
      ** Pay and Receive Settlement Methods
     D  I#RSTM               101    102
     D  I#PSTM               103    104
      ** Field 53 and 54 Entered
     D  I#5354               105    105
      ** Midas Module
     D  I#MMOD               106    107
      ** Pay and Receive Settlement Accounts
     D  I#PYAC               108    125
     D  I#RCAC               126    143
      ** Transaction Type
     D  I#TTYP               144    145
      ** Cover Required ?
     D  I#COVR               146    146
      ** Bank to Bank Information
     D  I#BTB                257    466
     D  I#BTB1               257    291
     D  I#BTB2               292    326
     D  I#BTB3               327    361
     D  I#BTB4               362    396
     D  I#BTB5               397    431
     D  I#BTB6               432    466
 
      ** Output Parameters from ME9940
 
     D O#PARM          DS           512
      ** Account Line modified
     D  O#ACLN                 1     35
      ** Bank to Bank Information
     D  O#BTB                257    466
     D  O#BTB1               257    291
     D  O#BTB2               292    326
     D  O#BTB3               327    361
     D  O#BTB4               362    396
     D  O#BTB5               397    431
     D  O#BTB6               432    466
 
      ** Error Information to/from ME9940
 
     D X#PARM          DS           256
      ** Calling Program
     D  X#CPGM                 1     10
      ** Error message sent
     D  X#ERRM                12     12
      ** Warning message sent
     D  X#WARN                13     13
      ** Error index
     D  X#INDX                14     18  0
      ** Message text to prefix error message
     D  X#MSGD                19     25
     D  X#MSGF                26     35
      ** Fields in error
     D  X#FLDS                36     41
      ** Error codes array
     D  X#ERCD                51    200
     D  O#E                   51    200
 
      ** Valid Alpha Numeric Codes
     D AlphaChar       S              1    DIM(25) CTDATA PERRCD(25)
     D Numeric         S              1    DIM(10) CTDATA PERRCD(10)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D DDCLSY          S              2A
     D DDCLID          S             15A
     D DDCOLC          S              2A
     D OKDDCLID        S              1A
     D WLEN            S              2S 0
     D WRTCD           S              7A
     D WOPTN           S              7A
 
      ** Index for arrays of error message ids etc
     D Idx             S              3S 0
 
      ** Program where the message from ME9940 will be sent
     D WPrgQ           S             10A
 
     D @RCODE          S              7A
     D Z#PARM          S            256A
 
     D DDCUSN          S              6A
     D DDCSID          S             12A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
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
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      '*BLANKS '    WRTCD
     C                   PARM      '*KEY    '    WOPTN
     C                   PARM                    DDCOLC
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C                   EVAL      I#PCCY = *BLANKS
     C                   IF        WRTCD = *BLANKS
     C                   EVAL      I#PCCY = A4CTAY
     C                   ENDIF
 
     C                   EVAL      OKDDCLID = 'Y'
      *
      ** Validation
      *
     C                   EXSR      SRCLID
      *
      ** If an error was found, set the return code appropriately
      *
     C     OKDDCLID      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      *  RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SRCLID - Validate Clearing Identification
      *****************************************************************
     C     SRCLID        BEGSR
 
     C                   IF        (DDCLSY = *BLANKS
     C                             AND DDCLID <> *BLANKS)
     C                   EVAL      OKDDCLID = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   MOVEL     'DDCLID'      FldNamXAr(Idx)
     C                   MOVEL     '5046092'     MsgIDXAr(Idx)
     C                   ELSE
 
     C                   IF        DDCLID <> *BLANKS
     C                   EXSR      CHK_SETTLE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** CHK_SETTLE -
      *****************************************************************
     C     CHK_SETTLE    BEGSR
 
     C                   EVAL      I#VFLD = DDCLID
     C                   EVAL      I#PR   = 'PAY'
 
     C                   IF        DDCSID <> *BLANKS
     C                   EVAL      I#PRTY = DDCSID
     C                   EVAL      I#PRTT = 'S'
     C                   ELSE
     C                   IF        DDCUSN <> *BLANKS
     C                   EVAL      I#PRTY = DDCUSN
     C                   EVAL      I#PRTT = 'C'
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      I#ACLN = '//' + DDCLSY + DDCLID
     C                   EVAL      I#MMOD = 'SD'
 
     C                   CALL      'ME9940'
 
     C                   PARM      *BLANKS       @RCODE
     C                   PARM                    I#PARM
     C                   PARM                    O#PARM
     C                   PARM      *BLANK        X#PARM
     C                   PARM      *BLANK        Z#PARM
     C
     C                   IF        X#ERRM = 'Y'
     C                             AND X#MSGD <> *BLANKS
     C                   EVAL      OKDDCLID = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   MOVEL     'DDCLID'      FldNamXAr(Idx)
     C                   MOVEL     '5046092'     MsgIDXAr(Idx)
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
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
      ** Other parms
      *
      ** Clearing system code
     C                   PARM                    DDCLSY
      ** Clearing identification
     C                   PARM                    DDCLID
      ** SWIFT ID
     C                   PARM                    DDCSID
      ** Customer number
     C                   PARM                    DDCUSN
      ** Country of location
     C                   PARM                    DDCOLC
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Other parms
      *
      ** Clearing identification- OK
     C                   PARM                    OKDDCLID
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
      ** Copyright must be defined for compile time array definition                      MD022862
**  CPY@
(c) Finastra International Limited 2013
**  AlphaChar
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**  Numeric
0123456789
