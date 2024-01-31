     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate trade book')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVTPOSN - Validate trade type against book position         *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSE119  *Create    Date 14Dec23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSE119 - Block TP Sale against Long Short Book Position      *
      *                                                               *
      *****************************************************************

     FBKPHD     IF A E           K DISK    COMMIT
     FBKPHH     IF   E           K DISK             RENAME(BKPHDDF:BKPHXX)
     FTRADSDV0  IF   E           K DISK             RENAME(TRADSDF:TRADXX)
     F                                              PREFIX(T_)
     F                                              IGNORE(HSTTRDF)

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

     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

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

     C                   Move      *Blanks       RetCodeIn

     C                   Move      *Blanks       FldNamXAr
     C                   Move      *Blanks       MsgIDXAr
     C                   Move      *Blanks       MsgDtaXAr
     C                   Z-Add     0             Idx

     C                   Move      'N'           BKPFLG            1
     C                   Z-Add     0             WTSNOM           11 0
     C                   Z-Add     0             WTPNOM           11 0
     C                   Z-Add     0             WDNOML           12 0
     C                   Move      *Blanks       WCNOML           12
 sg  C                   Z-Add     0             WTOTAL           11 0
      *
      ** Access book position file and if no matching record found
      ** access historic book position file, and then trades file.
      *
     C     KBKPHD        Setll     BKPHD                                  90
     C     *In90         Ifeq      *Off
     C     KBKPHD        Setll     BKPHH                                  91
     C     *In91         Ifeq      *Off
     C     KBKPHD        Setll     TRADSDV0                               92
     C                   Endif
     C                   Endif
      *
      ** Extend the checking to TRADSDV0 file to validate if position is
      ** short or long.
      *
     C     KBKPHD        Setll     TRADSDV0
     C     KBKPHD        ReadE     TRADSDV0                               94
     C     *In94         Doweq     *Off
      *
     C*****T_RECI        Ifeq      'D'
      *
     C                   Select
     C     T_TDTP        Wheneq    'TP'
     C                   Add       T_NOML        WTPNOM
     C     T_TDTP        Wheneq    'TS'
     C                   Add       T_NOML        WTSNOM
     C                   Endsl
      *
     C**********         Endif
      *
     C     KBKPHD        Reade     TRADSDV0                               94
     C                   Enddo
      *
      ** Perform ERROR processing if record found on either file
      *
     C     *In90         Ifeq      *On
     C     *In91         oreq      *On
     C     *In92         oreq      *On
      *
      ** Stop Trade Purchase against a long position of the same
      ** branch/book/market.
      *
     C                   EvalR     WCNOML = %TRIM(DDNOML)
     C                   Move      WCNOML        WDNOML
     C     DDTDTP        Ifeq      'TP'
     C     WTPNOM        Ifgt      WTSNOM
     C                   Move      'Y'           BKPFLG
     C                   Else
     C                   Add       WDNOML        WTPNOM
     C     WTPNOM        Ifgt      WTSNOM
     C                   Move      'Y'           BKPFLG
     C                   Endif
     C                   Endif
     C                   Endif
      *
      ** Stop Trade Sale against a short position of the same
      ** branch/book/market.
      *
     C     DDTDTP        Ifeq      'TS'
     C     WTPNOM        Iflt      WTSNOM
     C                   Move      'Y'           BKPFLG
     C                   Else
     C                   Add       WDNOML        WTSNOM
     C     WTPNOM        Iflt      WTSNOM
     C                   Move      'Y'           BKPFLG
     C                   Endif
     C                   Endif
     C                   Endif

     C     BKPFLG        Ifeq      'Y'
     C                   ADD       1             Idx
     C                   Move      'N'           DDTDMIOK
     C                   MoveL     'DDTDTP'      FldNamXAr(Idx)
     C                   MoveL     'ST11901'     MsgIdXAr(Idx)
     C                   Endif
     C                   Endif
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDTDMIOK      Ifeq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   Endif
      *
      * RETURN
      *
     C                   Return
      *
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
      ** Trade Screen fields
     C                   PARM                    DDSESN           10
     C                   PARM                    DDBRCD            3
     C                   PARM                    DDBPBK            2
     C                   PARM                    DDTDMI            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDNOML           12
     C                   PARM                    DDTDVD            7
     C                   PARM                    BJDFIN            1
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   PARM                    DDTDMIOK          1
      *
      ** Define Key fields
      *
     C     KBKPHD        KList
     C                   Kfld                    DDSESN
     C                   Kfld                    DDBRCD
     C                   Kfld                    DDBPBK
     C                   Kfld                    DDTDMI
      *
     C                   Move      *Blanks       ZFIELD
     C                   MoveL     DDTDVD        ZFIELD
     C                   CallB     'ZALIGN'
     C                   Parm                    ZALIGNok          1
     C                   Parm                    ZFIELD           16
     C                   Parm      0             ZADEC             1 0
     C                   Parm      6             ZADIG             2 0

     C     ZALIGNok      Ifeq      'Y'
     C                   Move      ZFIELD        ZDATEI
     C                   Callb     'ZDATE1'
     C                   Parm                    ZDATEI            6
     C                   Parm      *Zeros        ZDAYNO            5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
     C                   Endif

     C                   Z-Add     0             @TDVD             5 0
     C                   Z-Add     ZDAYNO        @TDVD

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
(c) Finastra International Limited 2023
