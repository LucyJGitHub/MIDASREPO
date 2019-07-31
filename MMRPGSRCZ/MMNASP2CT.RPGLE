     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs Purchased LUX Conversion')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  MMNASP2CT - MM NA Bought LUX Conversion from file format to  *
      *              its screen format                                *
      *                                                               *
      *  Function:  This module converts the fields of the extension  *
      *             file to their screen format.                      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
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
 
      ** NA Purchased Ext File - Transaction Details in File Format
     D NASPLuxFilFmt E DS                  ExtName(MMDBX2PD)
 
      ** NA Purchased Ext File - Transaction Details in Scrn Format
     D NASPLUXScnFmt E DS                  EXTNAME(MMNPRXPD)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D @KEY            S              3
 
     D P_Currency      S              3
 
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialisation
     C                   EXSR      SRInit
 
      ** Set screen fields
     C                   EXSR      SRSetFld
 
      ** Return
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialize Variables (Run Everytime)                *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Initialise program name
     C                   EVAL      DBPGM = 'MMNASP2CT'
 
      ** Clear output parameter
     C                   CLEAR                   NASPLUXScnFmt
 
      ** Access Currency Details
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      P_Currency    @KEY
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial processing                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUT
      ** Return Code (10A)
     C                   PARM                    RetCodein
      ** Curremcy (3A)
     C                   PARM                    P_Currency
      ** Extension File Formats
     C                   PARM                    NASPLuxFilFmt
 
      ** OUTPUT
      ** Extension Screen Format
     C                   PARM                    NASPLuxScnFmt
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   SRSetFld - Set Screen Fields                                *
      *                                                               *
      *****************************************************************
     C     SRSetFld      BEGSR
      *
     C                   MOVE(P)   VMLUSU        L6LXLUSU
     C                   MOVE      VMIM93        L6LXIM93
     C                   MOVE      VMCLAT        L6LXCLAT
     C                   MOVE      VMSUBR        L6LXSUBR
     C                   MOVE(P)   VMMOBL        L6LXMOBL
     C                   MOVE(P)   VMRISC        L6LXRISC
     C                   MOVE(P)   VMROFC        L6LXROFC
     C                   MOVE(P)   VMRATC        L6LXRATC
 
     C                   IF        VMSECQ   = 1
     C                   EVAL      L6LXSECQ = 'Y'
     C                   ELSE
     C                   EVAL      L6LXSECQ = 'N'
     C                   ENDIF
 
     C                   MOVE(P)   VMSECT        L6LXSECT
     C                   MOVE      VM1UAC        L6LXGUAC
     C                   MOVE      VMEVMT        L6LXEVMT
     C                   MOVE(P)   VMOPTP        L6LXOPTP
      *
     C                   IF        VMCOAM   = *Zeros
     C                   EVAL      L6LXCOAM = *Blanks
     C                   ELSE
     C                   MOVE(P)   VMCOAM        ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        L6LXCOAM
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program, and performs     *
      *           a ROLLBACK.                                         *
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
