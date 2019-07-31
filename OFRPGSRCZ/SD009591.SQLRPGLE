     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Validate Optimisation Payment Sub Type')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009591 - Validate a Midas System Value for the following:  *
      *             - Optimisation Payment Sub Type                   *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD038445           Date 25May16               *
      *                 CGL158   *CREATE   Date 16Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL158 - Nostro Sweeping Rules Maintenance                   *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======

      ** Midas Deal Sub-type File
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)

      ** Short Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Data structure for NewPaymVal string
     D NewPaymVal      DS           200
     D  DataToVal              1      2

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

      ** AODLSTR0 fields
     D @RTCD           S              7
     D @OPTN           S              7
     D @DSTC           S              2

      ** Working variables
     D DLCOUNT         S              7S 0 INZ(0)

      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Check if the Deal sub type code entered by the user is defined on
      ** the Deal sub type file

     C                   CALL      'AODLSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      DataToVal     @DSTC
     C     SDDLST        PARM      SDDLST        DSFDY

      ** If value entered by user is not found on the Midas Deal Sub Type
      ** file then return an error.

     C                   IF        @RTCD = '*NRF'
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR9897'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF

      ** If user entered '?', move selected Sub Type back to
      ** calling program
     C                   IF        DataToVal = '? ' OR
     C                             DataToVal = ' ?'
     C                   EVAL      NewPaymVal = @DSTC
     C                   ENDIF

      ** Check if valid Deal Type/Sub-Type combination

     C/exec SQL
     C+ SELECT COUNT(*) into: DLCOUNT from FDDTSTPD
     C+ where DTPE11 in ('NT', 'OP', 'IN') and
     C+       DLST11 = :DataToVal
     C/end-exec

     C                   IF        DLCOUNT <> 3
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C**********         MOVEL     'USR9899'     MsgIDXArr(Idx)                 MD038445
     C                   MOVEL     'USR9481'     MsgIDXArr(Idx)                 MD038445
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF

      ** Catchall for unprocessed errors

     C                   IF        @RTCD <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF

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
     C                   PARM                    NewPaymVal
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
