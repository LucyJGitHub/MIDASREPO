     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Nostro Transfer File to Screen Format')       *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTFTNTCVT - Midas FT Nostro Transfer Convert File to         *
      *              Screen Format                                    *
      *                                                               *
      *  Function:  This module converts the fields of a Nostro       *
      *             Transfer Details from file to screen format       *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP212  *CREATE    Date 15Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP212 - FT Nostro Transfer API                              *
      *                                                               *
      *****************************************************************
 
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
 
     D TranFilFmt    E DS                  EXTNAME(NTRANDD)
      ** Nostro Transfer Details in File Format
 
     D TrnDets       E DS                  EXTNAME(FTFTNTPD)
      ** Nostro Transfer Details in Screen Format
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY CODES
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRTCD           S              7
     D POPTN           S              7
     D PCCY            S              3
 
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ##ACTN          S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Initialisation
     C                   EXSR      INIT
 
      ** Set screen fields
     C                   EXSR      SCREEN
 
      ** Return
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      * Input Parameters
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Nostro Transfer Details File Format
     C                   PARM                    TranFilFmt
      *
 
      * Output Parameters
 
      * Nostro Transfer Details Screen Format
     C                   PARM                    TrnDets
 
      ** Initialise program name
     C                   EVAL      DBPGM = 'FTFTNTCVT'
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialisation
      *****************************************************************
     C     INIT          BEGSR
 
      ** Blank outputs (EXCEPT FOR ACTION CODE)
     C                   MOVEL     NTACTN        ##ACTN
     C                   MOVEL     *BLANK        TrnDets
     C                   MOVEL     ##ACTN        NTACTN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCREEN - SET SCREEN FIELDS
      *****************************************************************
     C     SCREEN        BEGSR
 
      * Transfer Reference
     C                   EVAL      NTTFRF = TFRF
 
      * Transfer Type
     C                   EVAL      NTTFTP = PYTP
 
      * Transfer Sub-Type
     C                   EVAL      NTTFST = PYST
 
      * Booking Branch
     C                   EVAL      NTBBRC = BRCA
 
      * Settlement Type
     C                   MOVE      STMT          NTSTMT
 
      * Swift Priority Code
     C                   IF        SWPC = 1
     C                   EVAL      NTSWFT = 'U'
     C                   ELSE
     C                   EVAL      NTSWFT = 'N'
     C                   ENDIF
 
      * Originating Branch
     C                   EVAL      NTOBRC = ORBR
 
      * Book Code
     C                   EVAL      NTBOKC = BOKC
 
      * Profit Centre
     C                   EVAL      NTPRFC = PRFC
 
      * From Nostro
     C                   MOVE      DEST          NTFNOS
 
      * To Nostro
     C                   MOVE      ACBN          NTTNOS
 
      * Currency
     C                   MOVE      CCY           NTCCY
 
      * Transfer Amount
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      CCY           PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      AMNT          ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        NTAMNT
 
      * Value Date
     C                   MOVE      VDATD1        NTVDAT
 
      * Intermediary Banks
     C                   EVAL      NTINT1 = NTINB1
     C                   EVAL      NTINT2 = NTINB2
     C                   EVAL      NTINT3 = NTINB3
     C                   EVAL      NTINT4 = NTINB4
     C                   EVAL      NTINT5 = NTINB5
 
      * Bank to Bank Informations
     C                   EVAL      NTBBI1 = BBI1
     C                   EVAL      NTBBI2 = BBI2
     C                   EVAL      NTBBI3 = BBI3
     C                   EVAL      NTBBI4 = BBI4
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT - Edit an unsigned field                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT         BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
 
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
      ****************************************************************
