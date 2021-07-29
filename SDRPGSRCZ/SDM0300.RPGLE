     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2017')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate Dept code for a system value')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDM0300  -  Validate a Midas System Value                    *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. EML106  *CREATE    Date 22Nov19               *
      * FBMidas 2.1 ---- Base ----------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML106 - Upgrade of EML013 to FB2.1 SP21                     *
      *       EML013 - Suppress Retail Account Bal. Check for Interf. *
      *                Batch                                          *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======

      ** Midas Department Codes File
     D SDDEPT        E DS                  EXTNAME(SDDEPTPD)

      ** Long Data Structure for Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Data structure for DpCodeVal string
     D DpCodeVal       DS           200

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Error message id in GBSDUSRMSG
     D ErrMsgId        S              7

      ** System value to be processed
     D SystemValue     S             20

      ** Processing mode
     D ProcMode        S             10

      ** General error indicator
     D GenError        S              1

      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0

      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)

      ** Department codes fields
     D Y               S              2  0 INZ(1)
     D DpMaxLen        S              2  0 INZ(30)
     D DpMaxItems      C                   CONSt(10)
     D DpCdArr         S              3    DIM(DpMaxItems)

     D DpCdArrV        S              3    DIM(DpMaxItems)
     D YV              S              2  0 INZ(1)
     D WBlank          S              1    INZ(' ')

      ** Access object parameters
     D PRTCD           S              7A
     D POPTN           S              7A
     D PDPCD           S              3A

      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   MOVEA     DpCodeVal     DpCdArr

      ** Check that there are no blanks embedded in the list of Dept codes
     C                   EVAL      WBlank = ' '
     C                   DOW       Y <= DpMaxItems
     C                   IF        DpCdArr(Y) =  *BLANKS
     C                   EVAL      WBlank = 'Y'
     C                   ELSE
     C                   IF        WBlank = 'Y'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'XXX9030'     MsgIDXArr(Idx)
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      Y = Y + 1
     C                   ENDDO
      *
      ** Check that there are no extra values/chars beyond char 30
     C                   If        %subst(DpCodeVal:(DpMaxLen+1)) <> *blanks
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'XXX9031'     MsgIDXArr(Idx)
     C                   ENDIF

      ** Check that the values entered all exist

     C                   EVAL      Y = 1
      *
     C                   DOW       Y <= DpMaxItems
      *
     C                   IF        DpCdArr(Y) <> *blanks
      *
     C                   CALL      'AODEPTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      DpCdArr(Y)    PDPCD
     C     SDDEPT        PARM      SDDEPT        DSSDY
      *
     C                   IF        PRTCD <> *blanks
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'XXX9032'     MsgIDXArr(Idx)
     C                   ELSE
     C     DpCdArr(Y)    LOOKUP    DpCdArrV                               99
     C                   IF        *IN99 = *ON
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'XXX9033'     MsgIDXArr(Idx)
     C                   ELSE
     C                   EVAL      DpCdArrV(YV)= DpCdArr(Y)
     C                   EVAL      YV = YV + 1
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      Y = Y + 1
      *
     C                   ENDDO
      *
     C                   IF        GenError = 'Y'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** Normal end processing
     C                   EVAL      GenError = ' '
     C                   EVAL      *INLR = *ON

     C                   RETURN
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** System value to be processed
     C                   PARM                    SystemValue
      ** Value entered by user
     C                   PARM                    DpCodeVal
      ** Processing Mode
     C                   PARM                    ProcMode
      ** General Error Indicator
     C                   PARM                    GenError
      ** Error message ID (number of entries)
     C                   PARM                    Idx
      ** Error message ID (array)
     C                   PARM                    MsgIDXArr

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      GenError = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR
