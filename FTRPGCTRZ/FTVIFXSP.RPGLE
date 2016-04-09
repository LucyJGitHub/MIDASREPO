     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP FX Spread Set')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subprograms                                 *
      *                                                               *
      *  FTVIFXSP - Validate FX Spread Set                            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG433             Date 02Dec05               *
      *                 CDL049             Date 06Jul06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009  *Create    Date 13Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  BUG433 - Recompiled due to change in FTXTRHL0                *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFTXTRHL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
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
 
      ** Include the standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
 
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
 
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NWIP1SCNFMT   E DS                  EXTNAME(FTIPY1PD)
     D NWIP1ASCNFMT  E DS                  EXTNAME(FTIPY1APD)
      *
      ** Incoming Payments Lvl 1 error indicators
     D OKIPY1DS      E DS                  EXTNAME(FTEIPY1PD)
      *
      ** Incoming Payments Valid extension file
     D NWIP2FILFMT   E DS                  EXTNAME(FTVIPY2PD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D IDX             S              3P 0
 
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
 
     C                   EVAL      RETCODEIN = *BLANKS
     C                   EVAL      FLDNAMXAR = *BLANKS
     C                   EVAL      MSGIDXAR  = *BLANKS
     C                   EVAL      MSGDTAXAR = *BLANKS
     C                   EVAL      IDX = 0
 
      ** FX Spread Set validation
 
     C                   EXSR      SRFXST
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        OKSPST = 'N'
     C                   EVAL      RETCODEIN = 'Error'
     C                   ELSE
     C                   EVAL      I2FXSP = SPDSET
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRFXST - Validate FX Spread Set                            *
      *                                                               *
      * Called By: Main Routine                                       *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SRFXST        BEGSR
      *
      ** Spread set must be blank, if settle currency = pay currency
      *
     C                   IF        DDPCCY = DDSMCY AND DDSMCY <> *BLANKS
     C                             AND DDPCCY <> *BLANKS
      *
     C                   IF        SPDSET <> *BLANKS
     C                   MOVE      'N'           OKSPST
     C                   ADD       1             IDX
     C                   MOVEL     'SPDSET'      FLDNAMXAR(IDX)
     C                   MOVEL     'FTF3157'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Must be a valid spread set if not blank
      *
     C                   IF        SPDSET <> *BLANKS
     C     SPDSET        SETLL     FTXTRHL0
      *
     C                   IF        NOT %EQUAL
     C                   MOVE      'N'           OKSPST
     C                   ADD       1             IDX
     C                   MOVEL     'SPDSET'      FLDNAMXAR(IDX)
     C                   MOVEL     'FTF3152'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/*INZSR     - Program Initialisation Routine                *
      *                                                               *
      * Called By: Automatically executed when program starts.        *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RETCODEIN
     C                   PARM                    NWIP1SCNFMT
     C                   PARM                    NWIP1ASCNFMT
     C                   PARM                    NWIP2FILFMT
     C                   PARM                    OKIPY1DS
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
