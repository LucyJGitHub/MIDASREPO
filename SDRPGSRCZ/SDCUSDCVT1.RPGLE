     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer BOE Conversion')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSDCVT1 - Midas SD Customer BOE Conversion                *
      *               File to Screen                                  *
      *                                                               *
      *  Function:  This module converts the fields of a Customer     *
      *             Transaction Detail from file to screen format     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. AR316373 *CREATE   Date 22Apr10               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR316373 - Conversion of Midas inputs to modular API         *
      *             structure.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
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
      ** SD Customer Transaction Details in File Format
      *
     D CusdExFilFmt  E DS                  EXTNAME(BYCUSTX0)
 
      *
      ** SD Customer Transaction Details in Screen Format
      *
     D CusdExScnFmt  E DS                  EXTNAME(SDCUEXPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Initialisation
      *
     C                   EXSR      SRINIT
      *
      ** Set screen fields
      *
     C                   EXSR      SRSETFLD
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialisation
      *****************************************************************
     C     SRINIT        BEGSR
 
      ** Blank outputs
     C                   MOVEL     *BLANK        CusdExScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCREEN - SET SCREEN FIELDS
      *****************************************************************
     C     SRSETFLD      BEGSR
      *
     C                   EVAL      SIOF = LSIOF
      *
     C                   EVAL      HASI = LHASI
      *
     C                   EVAL      UPAR = LUPAR
      *
     C                   EVAL      ELGF = LELGF
      *
     C                   EVAL      LINC = LLINC
      *
     C                   EVAL      LICD = LLICD
      *
     C                   EVAL      CNTP = LCNTP
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Input Parameters
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Customer Number
      *
     C                   PARM                    XXCUSN            6 0
      *
      ** SD Customer Transaction Details File Format
      *
     C                   PARM                    CusdExFilFmt
      *
      ** Output Parameter
      ** SD Customer Transaction Details in Screen Format
      *
     C                   PARM                    CusdExScnFmt
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
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
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2010
