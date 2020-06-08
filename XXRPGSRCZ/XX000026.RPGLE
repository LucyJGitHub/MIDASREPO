     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001          ')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate CNAPS Code')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Bespoke Module                                       *
      *                                                               *
      *  XX000026 - Validate CNAPS Codes                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. HUT110 *Create     Date 17Apr20               *
      *  Prev Amend No. nnnnnn             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT110 - Upgrade HUT022 to FBM 2.1 Sp22.                     *
      *           RTGS via SWIFT.                                     *
      *                                                               *
      *****************************************************************
      ** CNAPS Code details file
     FXXCNAPL1  IF   E           K DISK    INFSR(*PSSR)
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

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      * External DS for XXCNAPPD
     D XXCNAP        E DS                  EXTNAME(XXCNAPPD)

      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** DS for access programs - Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Work fields
     D HUT110          S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D PCNAP           S             12A
     D CNAPS_N         S             12  0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *********************************************************************
      /EJECT                                                              *
      *********************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      ** Initialize work fields
     C                   Clear                   XXCNAP
     C                   Eval      RetCodeIn = *Blanks
      *
      ** Convert received alpha CNAPS code to numeric
     C                   Move      PCNAP         CNAPS_n
      *
      ** Retrieve the record for the CNAPS Code received.
     C     CNAPS_n       Chain     XXCNAPL1                           99
     C                   If        *IN99 = *ON
     C                   Eval      RetCodeIn = '*NRF'
     C                   Endif
      *
     C                   Return
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeIn
      *  CNAPS Code
     C                   Parm                    PCNAP
      * OUTPUT
      *  CNAPS Code details (full record)
     C                   Parm                    XXCNAP
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

      ** Access SCSARDPD to determine if HUT110 is installed
     C                   Eval      HUT110 = 'N'
      *
     C                   CallB     'AOSARDR0'
     C                   Parm      *BLANKS       PRTCD
     C                   Parm      '*VERIFY'     POPTN
     C                   Parm      'HUT110'      PSARD
     C     SCSARD        Parm      SCSARD        DSFDY
      *
      ** NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   If        PRTCD <> *BLANKS and
     C                             PRTCD <> '*NRF   '
     C                   Eval      DBFILE = 'SCSARDPD'
     C                   Eval      DBASE = 01
     C                   Eval      DBKEY = 'HUT110'
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   If        PRTCD = *BLANKS
     C                   Eval      HUT110 = 'Y'
     C                   Endif
      *
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
