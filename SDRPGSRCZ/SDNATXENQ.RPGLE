     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-A/c Holder by Country of Tax Enquiry')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNATXENQ - Non-A/C Holders by Country of Tax Enquiry        *
      *                                                               *
      *  Function:  This is the enquiry function                      *
      *             for Non-account Holder Details.                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236137             Date 21Sep05               *
      *                 CGL032  *Create    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
 
      ** New Details in Screen Format
     D NwSflFmt      E DS                  Extname(SDNATXPD)
 
      ** Error Indicators
     D OkFlags       E DS                  Extname(SDENATXPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WScrn           S              1A
 
      ** Non-A/C Holder Work Field
     D PNAHO           S             10A
     D PLastCTTX       S              2A
     D PBDSFL          S              1A
     D PRDSFL          S              1A
     D PUPSFL          S              1A
     D PRepair         S              1A
     D PProtect        S              1A
     D WRdNxBr         S              1A
 
      ** Index of errors
     D Idx             S              3P 0
 
      ** Command Keys
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKL           S              1A
 
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
 
     C                   IF        WScrn = 'B'
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
 
     C                   CALLB     'SDNATXBRW'
 
      * Input Parameters :
 
      ** Return Code
      ** Non-a/c Holder
      ** Build subfile
      ** Read subfile record
      ** Update subfile record display
      ** Repair Mode Indicator
      ** Protect Fields
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM                    PNAHO
     C                   PARM      'Y'           PBDSFL
     C                   PARM      *Blanks       PRDSFL
     C                   PARM      *Blanks       PUPSFL
     C                   PARM      *Blanks       PRepair
     C                   PARM      'Y'           PProtect
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      * Output Parameters :
 
      ** Current Details in Screen Format
      ** Error Flags
      ** Read Next Record Flag
      ** Last CTTX displayed
      ** Command Keys
     C                   PARM      *Blanks       NwSflFmt
     C                   PARM      *All'Y'       OkFlags
     C                   PARM      'N'           WRdNxBr
     C                   PARM      *Blanks       PLastCTTX
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKE
     C                   PARM      '0'           PINKL
 
     C                   SELECT
 
      ** If F3 or F12 taken in browse, End Program
 
     C                   WHEN      PINKC = '1'
     C                             Or PINKL = '1'
     C                   EXSR      SREndP
 
     C                   WHEN      PINKE = '1'
     C                   EVAL      WScrn = 'B'
 
     C                   OTHER
     C                   EXSR      SREndP
 
     C                   ENDSL
 
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
 
     C                   EVAL      WScrn = 'B'
 
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
     C                   PARM                    PNAHO
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SDNATXENQ'
 
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
(c) Misys International Banking Systems Ltd. 2004
