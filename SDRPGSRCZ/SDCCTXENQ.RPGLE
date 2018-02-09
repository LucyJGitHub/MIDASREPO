     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details by Country of Tax Enq')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCCTXENQ - Customer by Country of Tax Enquiry               *
      *                                                               *
      *  Function:  This is the enquiry function                      *
      *             for Customer by Country of Tax.                   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236137             Date 21Sep05               *
      *                 CGL032  *Create    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  236137 - Change Control for CGL031 (Recompile)               *
      *  CGL032 - Automatic Exchange of Information.                  *
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      ** External DS for bank details
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  Extname(DSFDY)
 
      ** Current Details in Screen Format
     D CrDlScnFmt    E DS                  Extname(SDCCTXPD)
 
      ** New Details in Screen Format
     D NwDlScnFmt    E DS                  Extname(SDCCTXPD)
     D                                     Prefix(Cr)
 
      ** Error Indicators
     D OkFlags       E DS                  Extname(SDECCTXPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameter
     D PAction         S              1A
     D PCustNo         S              6A
 
     D WScrn           S              1A
 
      ** Non-A/C Holder Work Field
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D PUpSfl          S              1A
     D PRepair         S              1A
     D PProtect        S              1A
     D PRedisp         S              1A
     D PCtrySel        S              2A
     D PRTCD           S              7A
     D POPTN           S              7A
 
      ** Index of errors
     D Idx             S              3P 0
 
      ** Command Keys
     D PExit           S              1A
     D PCancel         S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
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
 
      ** Build browse subfile record
 
     C                   IF        WScrn = 'M'
     C                   EXSR      SRBldBrw
     C                   ENDIF
 
      ** Terminate program
 
     C                   IF        WScrn = 'T'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBldBrw - Build browse subfile                               *
      *****************************************************************
     C     SRBldBrw      BEGSR
 
      ** Build Browse subfile
 
     C                   CALLB     'SDCCTXBRW'
 
      * Input Parameters :
 
      ** Return Code
      ** Build subfile
      ** Read subfile record
      ** Update subfile record display
      ** Redisplay flag
      ** Customer Number
      ** Protect Fields
      ** Repair Mode Indicator
      ** Current Details in Screen Format
      ** Rundate
      ** Date Format Indicator
      ** Error Flags
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM      'Y'           PBdSfl
     C                   PARM      *Blanks       PRdSfl
     C                   PARM      *Blanks       PUpSfl
     C                   PARM      *Blanks       PRedisp
     C                   PARM                    PCustNo
     C                   PARM      'Y'           PProtect
     C                   PARM      *Blanks       PRepair
     C                   PARM      *Blanks       CrDlScnFmt
     C                   PARM                    BJMRDT
     C                   PARM                    BJDFIN
     C                   PARM      *All'Y'       OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      * Output Parameters :
 
      ** Read Next Record Flag
      ** Command Keys
      ** New Details in Screen Format
     C                   PARM      '0'           PExit
     C                   PARM      '0'           PCancel
     C                   PARM      *Blanks       PCtrySel
     C                   PARM      *Blanks       NwDlScnFmt
 
      ** Terminate program upon Exit or Enter is pressed
 
     C                   EXSR      SREndP
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SREndP - End Program                                          *
      *****************************************************************
     C     SREndP        BEGSR
 
     C                   EVAL      WScrn = 'T'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INITIAL Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR
 
     C                   EVAL      WScrn = 'M'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      ** Return Code
      ** Non-a/c Holder
     C                   PARM                    ReturnCode
     C                   PARM                    PAction
     C                   PARM                    PCustNo
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SDNATXENQ'
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY  =  POPTN
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBASE  =  001
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Go to initial screen
 
     C                   EXSR      INITIAL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
