     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - Read')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHLRED - Non-A/C Holder Details READ                      *
      *                                                               *
      *  Function:  This module READs forwards and backwards          *
      *             through the Non-A/C Holders file.                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CGL132             Date 01May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 31Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Standard Changes (Recompile)             *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL032 - Automatic Exchange of Information.                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Non-A/C Holders Details File
     FSDNAHOL1  IF   E           K Disk    Infsr(*PSSR)
     F                                     Rename(SDNAHOD0:NAHOREF)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ AutomatiCALLy included D-specs       ¦
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
 
      ** +--------------------------------------+
      ** ¦ End of automatiCALLy included D-specs¦
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
 
      ** External DS for Bank details
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  Extname(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** entry parameter fields
     D Retcd           S              7
     D Errcd           S              1  0
     D Action          S              1
     D Option          S              7
 
     D DDACTN          S              1
     D DDNAHO          S             10
     D @RDFWD          S              1
     D @RDBCK          S              1
     D @ERRMS          S              7
     D @NARED          S             10
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatiCALLy: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialise outputs
 
     C                   EVAL      @ERRMS = *BLANK
     C                   EVAL      @NARED = *BLANK
 
      ** Check for User authority to browse IF not multi-branching
 
     C                   IF        BJSBRC <> *BLANK
     C                   EXSR      SRCHAUTN
     C                   ENDIF
 
      ** Read forwards
 
     C                   IF        @RDFWD = 'Y'
     C                   EXSR      SRRDFWD
     C                   ELSE
 
      ** READ backwards
 
     C                   IF        @RDBCK = 'Y'
     C                   EXSR      SRRDBCK
     C                   ENDIF
 
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRDFWD - READ forwards through Non-A/C Holders files        *
      *****************************************************************
 
     C     SRRDFWD       BEGSR
 
      ** Position to current record on file
 
     C     DDNAHO        SETGT     NAHOREF
 
      ** READ until end of file or a valid record is found or an error
 
     C                   DOU       *IN99  =  *On      or
     C                             NHNAHO <> *BLANKS and
     C                             Errcd  =  *ZERO
 
      ** Read
 
     C                   READ      NAHOREF                                99
 
     C                   ENDDO
 
      ** IF end of file was encountered, report this fact
 
     C                   IF        *IN99  = *On
     C                   IF        DDNAHO = *BLANKS
     C                   EVAL      @ERRMS = 'MMM1006'
     C                   ELSE
     C                   EVAL      @ERRMS = 'MMM1002'
     C                   ENDIF
 
      ** Else, return the Non-A/C Holders reference read
 
     C                   ELSE
     C                   EVAL      @NARED = NHNAHO
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRRDBCK - READ backwards through Non-A/C Holders file        *
      *****************************************************************
 
     C     SRRDBCK       BEGSR
 
      ** Position to current record on file
 
     C     DDNAHO        SETLL     NAHOREF
 
      ** READ until end of file or a valid record is found or an error
 
     C                   DOU       *IN99  =  *On     or
     C                             NHNAHO <> *BLANKS and
     C                             Errcd  =  *ZERO
 
      ** READ authorized/not authorized
 
     C                   READP     NAHOREF                                99
 
     C                   ENDDO
 
      ** IF start of file was encountered, report this fact
 
     C                   IF        *IN99 = *On
     C                   EVAL      @ERRMS = 'MMM1003'
 
      ** Else  return the Non-A/C Holders Reference read
 
     C                   ELSE
     C                   EVAL      @NARED = NHNAHO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRCHAUTN - Check for User authority IF not multi-branching
      *****************************************************************
 
     C     SRCHAUTN      BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           Action
     C                   PARM                    Errcd
 
      ** RETURN error message
 
     C                   IF        Errcd = 1
     C                   EVAL      @ERRMS = 'FXM0292'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Initial Processing
      *****************************************************************
 
     C     *INZSR        BEGSR
 
 
     C     *Entry        Plist
 
      ** INPUTS :
      ** RETURN Code
      ** Action Code
      ** Non-A/C holders Ref. pointer
      ** READ Forwards
      ** READ Backwards
 
     C                   PARM                    RetCodeIn
     C                   PARM                    DDACTN
     C                   PARM                    DDNAHO
     C                   PARM                    @RDFWD
     C                   PARM                    @RDBCK
 
      ** OUTPUTS :
      ** Error meassage
      ** Non-A/C Holders Ref. READ
 
     C                   PARM                    @ERRMS
     C                   PARM                    @NARED
 
      ** Initialize program name
 
     C                   MOVEL     'SDNAHLRED'   Dbpgm
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     Retcd
     C                   PARM      '*FIRST '     Option
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        Retcd <> *BLANKS
     C                   MOVEL     'SDBANKPD'    Dbfile
     C                   MOVEL     '901'         Dbase
     C                   MOVEL     Option        Dbkey
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
