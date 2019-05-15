     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate sec price data source override')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEVSPDS01 - Validate Sec Price Data Source Override          *
      *              Called when CSD006 is on                         *
      *                                                               *
      *    This optional field identifies the data provider that will *
      *    supply the price for this security. If not entered, the    *
      *    system will use the default Sec Price MDDSPS on the MDF    *
      *    ICD.If entered it must be a valid MDF data source code.    *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CSD006  *CREATE    Date 12Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD006 - Midas APIs, Security Prices Full API                *
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
 
     D SDMDFS        E DS                  EXTNAME(SDMDFSPD)
     D SDMDFC        E DS                  EXTNAME(SDMDFCPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
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
 
     C                   MOVE      *BLANK        RetCodeIn
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
      *
      * Initialise output fields
 
     C                   MOVEL     *BLANK        SPDS
 
      * Validate Sec Price Data Source Override
      * =======================================
 
     C                   EXSR      SPDSval
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDSPDSOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SPDSval  - Sec Price Data Source Override validation
      *****************************************************************
     C     SPDSval       BEGSR
 
      * If the Sec Price Data Source Override is blank, use the default Sec Price
      * MDDSPS on the MDF ICD
 
     C                   IF        DDSPDS = *BLANKS
     C                   CALLB     'AOMDFCR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMDFC        PARM      SDMDFC        DSSDY
 
     C                   IF        @RTCD <> *Blanks
     C                   MOVEL     'SDMDFCPD'    DBFILE
     C                   MOVEL     '080'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
      *
      ** The field is optional. If entered, it must refer to a valid MDF
      ** Source Code on PF/SDMDFSPD (validated via the access object AOMDFSR0).
      *
     C                   MOVE      DDSPDS        WSPDS
     C                   MOVEL     DDSPDS        QMARK             1
 
     C                   CALLB     'AOMDFSR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    WSPDS            32
     C     SDMDFS        PARM      SDMDFS        DSFDY
 
     C                   IF        @RTCD  =   *BLANK AND QMARK = '?'
     C                   EVAL      REDSPLY  =  'Y'
     C                   ENDIF
 
     C                   IF        @RTCD  =   *BLANK
     C                   MOVE      WSPDS         SPDS
     C                   MOVE      WSPDS         DDSPDS
     C                   ELSE
     C                   MOVE      'N'           DDSPDSOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDSPDS'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0446'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
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
      ** Security Price Data Source Override
     C                   PARM                    DDSPDS           32
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Security Price ID
     C                   PARM                    SPDS             32
      ** Security Price Id OK flag
     C                   PARM                    DDSPDSOK          1
      ** Redisplay screen
     C                   PARM                    REDSPLY           1
 
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
