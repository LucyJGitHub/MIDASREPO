     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Total VAT Field')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVTVAT - Midas FT Validate Total VAT Field                  *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT157             Date 29Aug14               *
      *                 AR1096208          Date 17Apr13               *
      *                 AR1080804          Date 27Jan13               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067  *CREATE    Date 05Oct10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  AR1096208 - System defaulted VAT Ind as checked in charges   *
      *              details 2 tab but the system do not compute for  *
      *              VAT amount                                       *
      *  AR1080804 - The ff errors occurred 45037422 Invalid Amount   *
      *              (Field: Total VAT Charge) even if no VAT amount  *
      *              was inerted.                                     *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **********************************************************************
      /EJECT                                                               *
      **********************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY6PD)
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY4PD)
 
      ** Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      ** External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for access programs (short)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D @CURR           S              3
 
     D ZalignOK        S              1
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0
                                                                                           AR1080804
     D STOTVAN         S             16P 0                                                 AR1080804
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *********************************************************************
      /EJECT                                                              *
      *********************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      Idx = 0
     C                   EVAL      @TVAT = 'N'
     C                   EVAL      OKTVAT = 'N'
 
     C                   MOVE      STOTVA        STOTVAN                                   AR1080804
     C**********         IF        STOTVA <> *BLANKS                                       AR1080804
     C                   IF        STOTVAN <> 0                                            AR1080804
     C                   EVAL      @TVAT = 'Y'
 
      ** Currency details
     C                   EXSR      VSETCUR
 
      ** Settle amount validation
     C                   EXSR      VSETAMT
     C                                                                                     AR1080804
     C                   ELSE                                                              AR1080804
     C                                                                                     AR1080804
     C                   MOVE      'Y'           OKTVAT                                    AR1080804
     C**********         MOVE      STOTVAN       @VATD                           AR1080804 AR1096208
     C                                                                                     AR1080804
     C                   ENDIF
 
      ** If an error was found, set the return code appropriately
     C                   IF        OKTVAT = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
      ******************************************************************
      /EJECT                                                           *
      ******************************************************************
      *                                                                *
      * VSETCUR - Validation of Settle Currency                        *
      *                                                                *
      ******************************************************************
     C     VSETCUR       BEGSR
 
      ** Access Currency File
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BlankS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @CCCY         @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        @RTCD <> *BlankS
 
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @CCCY         DBKEY
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
     C*****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * VSETAMT - Validation of Settle Amount                         *
      *                                                               *
      *****************************************************************
     C     VSETAMT       BEGSR
 
      ** If entered validate
     C                   IF        STOTVA <> *BLANKS
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      STOTVA        ZFIELD
     C                   EXSR      VZALIGN
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * VZALIGN - Validation of numeric field                         *
      *                                                               *
      *****************************************************************
     C     VZALIGN       BEGSR
 
     C                   EVAL      ZADIG = 13 - @PCDP
     C                   EVAL      ZADEC = @PCDP
 
      ** Validate amount as numeric with correct d.p.
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOK          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
 
     C                   IF        ZalignOK = 'N'
 
      ** Send error to screen
     C                   ADD       1             Idx
     C                   MOVEL     'STOTVA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0574'     MsgIdXAr(Idx)
 
     C                   ELSE
 
     C                   MOVE      'Y'           OKTVAT
     C                   MOVE      ZFIELD        @VATD
 
     C                   ENDIF
 
     C                   ENDSR
     C*****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Screen fields
     C                   PARM                    TranInPrim
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** OK Flags
     C                   PARM                    OKFlagsDS
 
      ** Validation Work Fields
     C                   PARM                    Val@Fields
 
      ** =================================================================
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
(c) Finastra International Limited 2010
