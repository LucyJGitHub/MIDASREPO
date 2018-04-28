     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Validate Deal Subtype for a system value')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Processing Module                           *
      *                                                               *
      *  SD009597 - Validation program for System Value               *
      *             EQEventDealSubtype                                *
      *                                                               *
      *  Function: This program will call a new Access object         *
      *             AODLSTR0 and check if the value entered by the    *
      *             User in EQEventDealSubtype exists in Deal Sub type*
      *             file                                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  U7+U8 - Database Error                                       *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR      - Initialisation                                 *
      *  *PSSR       - DB Error Processing                            *
      *                                                               *
      *****************************************************************
 
      ** F-specs
      ** =======
 
      ** Midas FD Deal type/subtype logical file
     FFDDTSTL1  IF   E           k DISK    INFSR(*PSSR)
      ** Definition Changes
      **
      ** Define Following Data Structures:
      **
      ** Midas SD Deal sub-types
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
 
      ** Short Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data structure for NewCurrVal string
     D NewDLSTVal      DS           200
     D DataToVal               1      2
 
      ** Work variable for deal sub-type
     D W_DSTC          S              2A
      ** Define the fields used in the key list
     D K02_DTPE11      S              2A
     D K02_DLST11      S              2A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message id in SDUSRMSG
     D ErrMsgId        S              7
 
      ** System value to be processed
     D SystemValue     S             20
 
      ** Processing mode
     D ProcMode        S            190
 
      ** Return Flag
     D Rflag           S              1
 
      ** Index for arrays of error message ids etc
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
 
      ** Check if the Deal sub type code entered by the user is defined on
      ** the Deal sub type file
 
     C                   CALL      'AODLSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      DataToVal     @DSTC             2
     C     SDDLST        PARM      SDDLST        DSFDY
 
      ** If value entered by user is not found on the Midas Deal Sub Type
      ** file then return an error.
 
     C                   IF        @RTCD = '*NRF'
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR0760'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** Catch all for unprocessed errors
 
     C                   IF        @RTCD <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      W_DSTC = ASDSTC
      ** Key list for the Deal type/Sub type file
 
     C     K02_FDDTSTL1  KList
     C                   KFld                    K02_DTPE11
     C                   KFld                    K02_DLST11
      ** Chain the Deal type/Sub type file using Deal type as 'CL"
 
     C                   EVAL       K02_DTPE11 = 'CL'
     C                   EVAL       K02_DLST11 =  W_DSTC
      **
     C     K02_FDDTSTL1  CHAIN     FDDTSTL1
     C                   IF        NOT %FOUND(FDDTSTL1)
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR4219'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
      **
      ** Chain the Deal type/Sub type file using Deal type as 'CD"
 
     C                   EVAL       K02_DTPE11 = 'CD'
      **
     C     K02_FDDTSTL1  CHAIN     FDDTSTL1
     C                   IF        NOT %FOUND(FDDTSTL1)
     C                   EVAL      Rflag = 'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'USR4219'     MsgIDXArr(Idx)
     C                   EVAL       *INLR = *ON
     C                   RETURN
     C                   ENDIF
      **
      ** Normal end processing
 
     C                   EVAL      RFlag = ' '
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** System value to be processed
     C                   PARM                    SystemValue
      ** Value entered by user
     C                   PARM                    NewDLSTVal
      ** Processing Mode
     C                   PARM                    ProcMode
      ** Return Flag
     C                   PARM                    RFlag
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
 
     C                   EVAL      RFlag = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
