     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Nostro Transfer Validate Transfer Amount')    *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVAMNT - Midas FT Nostro Transfer Validate Transfer Amount  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CAP212  *CREATE    Date 15Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP212 - FT Nostro Transfer API                              *
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Transfer Details in screen format
     D TrnDets       E DS                  EXTNAME(FTFTNTPD)
 
      ** Transfer Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(FTEFTNTPD)
 
      ** Valid Transfer Details layout
     D ValidNoTr     E DS                  EXTNAME(FTVFTNTPD)
 
      ** External DS for Currency Codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
     D PRTCD           S              7
     D POPTN           S              7
     D PCCY            S              3
     D WNBDP           S              1  0
     D WSPRT           S             13  8
     D WMDIN           S              1
     D WAMNT           S             13  0
     D WDIV            S              4  0
     D N               S              1  0
     D WK159           S             15  9
     D BASCCY          S              3
 
     D POWER           S              7  3 DIM(7) PERRCD(1) CTDATA
 
     D/COPY ZSRSRC,ZALIGNZ1LE
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
 
     C                   MOVE      *BLANK        ReturnCode
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
 
      *
      ** VALIDATION
 
      ** Transfer Amount must be entered
     C                   IF        NTAMNT = *BLANKS
      *
     C                   EVAL      OKAMNT = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTAMNT    '
     C                   EVAL      MsgIdXAr(Idx) = '5047447'
     C                   GOTO      EMAIN
      *
     C                   ENDIF
 
      ** Do next validations only if currency is valid
     C                   IF        OKCCY <> 'Y'
     C                   GOTO      EMAIN
     C                   ENDIF
 
      ** Retrieve details for currency
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      NVCCY         PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   Z-ADD     A6NBDP        WNBDP
     C                   Z-ADD     A6SPRT        WSPRT
     C                   MOVE      A6MDIN        WMDIN
 
      ** Validate amount
     C                   Z-ADD     WNBDP         ZADEC
     C     13            SUB       WNBDP         ZADIG
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NTAMNT        ZFIELD
      *
     C                   EXSR      ZALIGN
      *
     C                   IF        *IN99 = *ON
      *
     C                   EVAL      OKAMNT = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTAMNT    '
     C                   EVAL      MsgIdXAr(Idx) = '5047448'
     C                   GOTO      EMAIN
      *
     C                   ENDIF
 
      ** Transfer amount must be non-zero
     C                   Z-ADD     *ZEROS        WAMNT
     C                   MOVE      ZFIELD        WAMNT
     C                   IF        WAMNT = *ZEROS
      *
     C                   EVAL      OKAMNT = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTAMNT    '
     C                   EVAL      MsgIdXAr(Idx) = '5047449'
     C                   GOTO      EMAIN
      *
     C                   ENDIF
 
      * Move value to valid file
     C                   Z-ADD     WAMNT         NVAMNT
     C                   SELECT
     C                   WHEN      WNBDP = *ZERO
     C                   Z-ADD     1             WDIV
     C                   WHEN      WNBDP = 1
     C                   Z-ADD     10            WDIV
     C                   WHEN      WNBDP = 2
     C                   Z-ADD     100           WDIV
     C                   WHEN      WNBDP = 3
     C                   Z-ADD     1000          WDIV
     C                   ENDSL
     C     WAMNT         DIV(H)    WDIV          NVAMTD
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      BASCCY        PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     WNBDP         SUB       A6NBDP        N
     C                   ADD       4             N
     C                   IF        WMDIN = 'D'
     C     A6SPRT        MULT(H)   POWER(N)      WK159
     C     WAMNT         DIV(H)    WK159         NVSBCQ
     C                   ELSE
     C     A6SPRT        DIV(H)    POWER(N)      WK159
     C     WAMNT         MULT(H)   WK159         NVSBCQ
     C                   ENDIF
 
      * RETURN
 
     C     EMAIN         TAG
 
     C                   RETURN
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
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      * OK Flags
     C                   PARM                    OKTrnDets
      *
      * Validation Fields
     C                   PARM                    ValidNoTr
 
      *
      * Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   MOVE      BJCYCD        BASCCY
      *
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
     C/COPY ZSRSRC,ZALIGNZ2LE
      ********************************************************************
      /EJECT
      ********************************************************************
**CTDATA POWER
0000001
0000010
0000100
0001000
0010000
0100000
1000000
