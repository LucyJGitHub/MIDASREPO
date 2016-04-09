     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/Deposits LUX Conversion')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  MMLDNI2CT - MM Loans/Deposits LUX Conversion                 *
      *              File to Screen Format                            *
      *                                                               *
      *  Function:  This module converts the fields of MMDLX1PD       *
      *             Transaction Detail from file to screen format     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
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
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      *
      ** Loans/Deposits Ext File - Transaction Details in File Format
      *
     D LDNILUXFilFmt E DS                  ExtName(MMDLX1PD)
      *
      ** Loans/Deposits Ext File - Transaction Details in Scrn Format
      *
     D LDNILUXScnFmt E DS                  EXTNAME(MMLDRXPD)
      *
      ** External DS for Currency Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D @KEY            S              3
      *
     D p_Return        S             10
     D p_TradeRef      S              6
     D p_Currency      S              3
      *
     D ZFIELD          S             16
     D ZADEC           S              1  0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      **************************************************************
      /EJECT
      **************************************************************
      *
      ** Initialisation
      *
     C                   EXSR      Sr_Init
      *
      ** Set screen fields
      *
     C                   EXSR      Sr_SetFld
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** Sr_Init - Initialize Variables (Run Everytime)               *
      *                                                               *
      *****************************************************************
      *
     C     Sr_Init       BEGSR
      *
     C                   CLEAR                   LDNILUXScnFmt
     C                   CLEAR                   ZFIELD
      *
      ** Initialise program name
      *
     C                   EVAL      DBPGM = 'MMLDNI2CT'
      *
      ** Access Currency Details
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      p_Currency    @KEY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Database Error
      *
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - INITIAL PROCESSING                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** Return Code (10A)
      ** Trade Reference (6A)
      ** Curremcy (3A)
      ** Extension File Format
      *
     C                   PARM                    p_Return
     C                   PARM                    p_TradeRef
     C                   PARM                    p_Currency
     C                   PARM                    LDNILUXFilFmt
      *
      ** OUTPUT
      ** Extension Screen Format
      *
     C                   PARM                    LDNILUXScnFmt
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** Sr_SetFld - Set Screen Fields                                *
      *                                                               *
      *****************************************************************
      *
     C     Sr_SetFld     BEGSR
      *
     C                   MOVE      VLLUSU        L6LXLUSU
     C                   MOVE      VLIM93        L6LXIM93
     C                   MOVE      VLCLAT        L6LXCLAT
     C                   EVAL      L6LXSUBR = VLSUBR
     C                   EVAL      L6LXMOBL = VLMOBL
     C                   MOVE      VLRISC        L6LXRISC
     C                   MOVE      VL1UAC        L6LXGUAC
     C                   MOVE      VLIMEX        L6LXIMEX
     C                   MOVE      VLPPSC        L6LXPPSC
      *
     C                   IF        VLCOAM = *Zeros
     C                   EVAL      L6LXCOAM = *Blanks
     C                   ELSE
     C                   MOVE      VLCOAM        ZFIELD
     C                   EVAL      ZADEC = A6NBDP
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        L6LXCOAM
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** ZEDIT - Edit an unsigned field                               *
      *                                                               *
      *****************************************************************
      *
     C     ZEDIT         BEGSR
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** *PSSR  - Program exception error routine                     *
      **          Called automatically if a program error occurs,     *
      **          or directly by the program code using EXSR.         *
      **          This subroutine DUMPs the program, and performs     *
      **          a ROLLBACK.                                         *
      *                                                               *
      *****************************************************************
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
