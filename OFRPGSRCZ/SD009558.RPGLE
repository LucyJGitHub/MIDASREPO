     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas OF Validate No Match Account Code')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009558 - Midas OF Validate No Match Account Code           *
      *             for a system value.                               *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL135   *CREATE   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL135 - Accounting Rules Process                            *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======

      ** Midas Account Codes File
     D SDACOD        E DS                  EXTNAME(SDACODPD)

      ** Long Data Structure for Access Objects
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Data structure for AcCodeVal string
     D AcCodeVal       DS           206
     D  DataToVal              1     10

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Error message id in GBSDUSRMSG
     D ErrMsgId        S              7

      ** System value to be processed
     D SystemValue     S             20

      ** Processing mode
     D ProcMode        S            190

      ** General error indicator
     D GenError        S              1

      ** Index for arrays of of error message ids etc
     D Idx             S              2P 0

      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)

      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Check if the account code entered by the user is defined on
      ** the Midas account codes file

     C                   IF        ProcMode = 'AC_CODE   '
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      DataToVal     @PFTC            10
     C     SDACOD        PARM      SDACOD        DSSDY                                        CRE0

      ** If value entered by user is not found on the Midas account codes
      ** file then return an error

     C                   IF        @RTCD = '*NRF'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR9862'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF

      ** Return the selected field

     C                   EVAL      DataToVal = *BLANKS
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      DataToVal = A5ACCD
     C                   ENDIF
     C                   IF        @RTCD = '*NOSEL'
     C                   EVAL      DataToVal = *BLANKS
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR4617'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF

      ** If the record is present on the Midas account codes file then peform
      ** further checks

      **  Check that this is a non-title account code

     C                   IF        ProcMode = 'AC_TITLE  '
     C                             AND A5TOIN = 'Y'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR9861'     MsgIDXArr(Idx)
     C                   RETURN
     C                   ENDIF

      **  Check for account type

     C                   IF        ProcMode = 'AC_TYPE   '
     C                             AND A5ACTY <> 'G'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR9861'     MsgIDXArr(Idx)
     C                   RETURN
     C                   ENDIF


      ** Catchall for unprocessed errors

     C                   IF        @RTCD <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Normal end processing

     C                   EVAL      GenError = ' '

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
     C                   PARM                    AcCodeVal
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
