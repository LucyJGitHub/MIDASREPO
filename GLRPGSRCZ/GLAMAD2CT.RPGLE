     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account LUX Convert')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMAD2CT- GL Accnt. LUX Conversion : File to Screen Format  *
      *                                                               *
      *  Function: This module converts the fields of REACX1PD        *
      *            Transaction Detail from file to screen             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027A            Date 09May06               *
      *  Prev Amend No. BUG10444           Date 07Feb06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  BUG10444 - Lum sum code not defined due to the wrong         *
      *             representation of value coming from aptranr       *
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
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
     D AcctLUXFilFmt E DS                  EXTNAME(REACX1PD)
      *
      ** REACX1PD Transaction Details in File Format
      *
     D AcctLUXScnFmt E DS                  EXTNAME(GLAMRXPD)
      *
      ** REACX1PD Transaction Details in Screen Format
      *
     D SDCurr        E DS                  EXTNAME(SDCURRPD)
      *
      ** External DS for Currency Details
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
      *
      ** Key fields definition
      *
     D*Customer*       S              6S 0                                                   CSD027A
     D Customer        S              6                                                      CSD027A
     D Currency        S              3
     D Accountcd       S             10
     D Acctseqnc       S              2S 0
     D Branch          S              3
      *
      ** Parameters definition
      *
     D PRTCD           S              7
     D POPTN           S              7
     D PKEY            S              3
     D ZField          S             16
     D ZaDec           S              1  0
      *
      *****************************************************************
      *
     C     KEY           KLIST
     C                   KFLD                    Customer
     C                   KFLD                    Currency
     C                   KFLD                    Accountcd
     C                   KFLD                    Acctseqnc
     C                   KFLD                    Branch
      *
      ** Initialisation
      *
     C                   EXSR      SrInit
      *
      ** Set screen fields
      *
     C                   EXSR      SrSetFld
      *
      ** Return
      *
     C                   EVAL      *INLR=*ON
     C                   RETURN
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    Customer
     C                   PARM                    Currency
     C                   PARM                    Accountcd
     C                   PARM                    Acctseqnc
     C                   PARM                    Branch
     C                   PARM                    AcctLUXFilFmt
     C                   PARM                    AcctLUXScnFmt
 
     C                   ENDSR
      *****************************************************************
     C     SrInit        BEGSR
 
     C                   CLEAR                   AcctLUXScnFmt
     C                   CLEAR                   ZFIELD
      *
      ** Initialise program name
      *
     C                   EVAL      DBPGM = 'GLAMAD2CT'
      *
      ** Access Currency Details
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      Currency      PKEY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Database Error
      *
     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C     SrSetFld      BEGSR
 
     C                   EVAL      L6LXCOBR=WECOBR
     C                   EVAL      L6LXCOAC=WECOAC
     C**********         EVAL      L6LXLUSU=%CHAR(WELUSU)                                   BUG10444
     C                   MOVE      WELUSU        L6LXLUSU                                   BUG10444
     C                   EVAL      L6LX1UAC=%CHAR(WE1UAC)
      *
     C                   IF        WECOAM=0
     C                   EVAL      L6LXCOAM=' '
     C                   ELSE
     C                   EVAL      ZaDec=A6NBDP
     C                   MOVE      *ZERO         ZField
     C                   MOVE      WECOAM        ZField
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZField
     C                   PARM                    ZaDec
      *
     C                   MOVE      ZField        L6LXCOAM
     C                   ENDIF
 
     C                   ENDSR
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
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
