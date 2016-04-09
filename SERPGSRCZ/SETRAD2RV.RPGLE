     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trades LUX Retrieve')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SETRAD2RV - SE TRAD LUX Retrieve                             *
      *                                                               *
      *  Function:  This module retrieves a transaction from          *
      *             the database.                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG11641           Date 04Jul06               *
      *  Prev Amend No. CER001  *Create    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG11641-Trade reference number should be reflected in the   *
      *           confirmation page                                   *
      *  CER001 - LUX Upgrade to MidasPlus.                           *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     F***SETRX1PD  IF   E           K DISK    INFSR(*PSSR)                                  BUG11641
     FSETRX1L0  IF   E           K DISK    INFSR(*PSSR)                                     BUG11641
      *
      ** TRAD Extension file
      *
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
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
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for bank details ICD retrieval
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for access programs, short data structure
      *
     D TRADLUXFilFmt E DS                  EXTNAME(SETRX1PD)
      *
      ** TRAD Extension File Format
      *
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of of error message ids etc
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      ** Initialisation
      *
     C                   EXSR      INIT
      *
     C*****KLTRAD        CHAIN     SETRX1PD                                                 BUG11641
     C     KLTRAD        CHAIN     SETRX1L0                                                 BUG11641
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initial processing
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Clear Outputs
      *
     C                   CLEAR                   TRADLUXFilFmt
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initialisation
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      ** Return code
      *
     C                   PARM                    RetCodeIn
      *
      ** Action Code
      *
     C                   PARM                    ActionCode
      *
      ** Front Office Transaction ID
      *
     C                   PARM                    FOTRID           20
      *
      ** Reference
      *
     C                   PARM                    SecRef            6
      *
      ** Outputs
      ** Extension File Format
      *
     C                   PARM                    TRADLUXFilFmt
      *
      **  GET RUNDAT to access MULTI-BRANCHING flag.
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  =  900
     C                   EVAL      DBKEY = @OPTN
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      *
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
 
     C     KLTRAD        KLIST
     C                   KFLD                    SecRef
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *
      ** Note: if non-standard processing required, use the PSSR_ILENE
      ** subroutine
      *
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
