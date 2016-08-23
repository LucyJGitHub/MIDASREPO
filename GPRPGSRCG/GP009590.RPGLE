     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Validate against another system value')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP009590 -  Validate against another system value            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031  *CREATE    Date 10Apr06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *                                                               *
      *****************************************************************
      ** D-specs
      ** =======
      ** Paramter List for GPAOSVALR0
 
     D PSysVal01       S             20A   INZ('NarCodeStartRange')
     D PCurSet01       S            200A
     D PSysVal02       S             20A   INZ('NarCodeEndRange')
     D PCurSet02       S            200A
     D PSysVal03       S             20A   INZ('AcctOfcrStartRange')
     D PCurSet03       S            200A
     D PSysVal04       S             20A   INZ('AcctOfcrEndRange')
     D PCurSet04       S            200A
     D PSysVal05       S             20A   INZ('BaseRateStartRange')
     D PCurSet05       S            200A
     D PSysVal06       S             20A   INZ('BaseRateEndRange')
     D PCurSet06       S            200A
     D PSysVal07       S             20A   INZ('BookCodeStartRange')
     D PCurSet07       S            200A
     D PSysVal08       S             20A   INZ('BookCodeEndRange')
     D PCurSet08       S            200A
     D PSysVal09       S             20A   INZ('BrkrCodeStartRange')
     D PCurSet09       S            200A
     D PSysVal10       S             20A   INZ('BrkrCodeEndRange')
     D PCurSet10       S            200A
 
      ** System value to be processed
 
     D SystemValue     S             20
 
      ** Processing mode
 
     D ProcMode        S            190
 
      ** General error indicator
 
     D GenError        S              1
 
      ** Ending range
 
     D EndRange        S            200
 
      ** Error message id in GBSDUSRMSG
 
     D ErrMsgId        S              7
 
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
      ** Retrieving the system values
 
     C                   CALLB     'GPAOSVALR0'
     C                   PARM      *BLANKS       PRtCd             7
     C                   PARM                    PSysVal01
     C                   PARM                    PCurSet01
     C                   PARM                    PSysVal02
     C                   PARM                    PCurSet02
     C                   PARM                    PSysVal03
     C                   PARM                    PCurSet03
     C                   PARM                    PSysVal04
     C                   PARM                    PCurSet04
     C                   PARM                    PSysVal05
     C                   PARM                    PCurSet05
     C                   PARM                    PSysVal06
     C                   PARM                    PCurSet06
     C                   PARM                    PSysVal07
     C                   PARM                    PCurSet07
     C                   PARM                    PSysVal08
     C                   PARM                    PCurSet08
     C                   PARM                    PSysVal09
     C                   PARM                    PCurSet09
     C                   PARM                    PSysVal10
     C                   PARM                    PCurSet10
 
      ** Catchall for unprocessed errors
 
     C                   IF        PRtCd <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Compare that the EndRange is greater than the retrieved
      ** NarCodeStartRange
 
     C                   IF        SystemValue = 'NarCodeEndRange'
     C     EndRange      COMP      PCurSet01                            91
     C                   IF        *In91 = *ON
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'CSD0010'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Compare that the EndRange is greater than the retrieved
      ** AcctOfcrStartRange
 
     C                   IF        SystemValue = 'AcctOfcrEndRange'
     C     EndRange      COMP      PCurSet03                            91
     C                   IF        *In91 = *ON
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'CSD0010'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Compare that the EndRange is greater than the retrieved
      ** BaseRateStartRange
 
     C                   IF        SystemValue = 'BaseRateEndRange'
     C     EndRange      COMP      PCurSet05                            91
     C                   IF        *In91 = *ON
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'CSD0010'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Compare that the EndRange is greater than the retrieved
      ** BookCodeStartRange
 
     C                   IF        SystemValue = 'BookCodeEndRange'
     C     EndRange      COMP      PCurSet07                            91
     C                   IF        *In91 = *ON
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'CSD0010'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Compare that the EndRange is greater than the retrieved
      ** BrkrCodeStartRange
 
     C                   IF        SystemValue = 'BrkrCodeEndRange'
     C     EndRange      COMP      PCurSet09                            91
     C                   IF        *In91 = *ON
     C                   EVAL      GenError = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'CSD0010'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Normal end processing
 
     C                   EVAL      GenError = ' '
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** System value to be processed
 
     C                   PARM                    SystemValue
 
      ** Ending range
 
     C                   PARM                    EndRange
 
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
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
