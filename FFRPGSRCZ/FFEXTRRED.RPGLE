     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Transactions read')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFEXTRRED - EXCHANGE-TRADED READ                             *
      *                                                               *
      *  Function:  This module reads forwards and backwards          *
      *             through the Futures and Options Exchange-traded   *
      *             file.                                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS002             Date 14Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 26Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS002 - Hedge Strategy/Linkage (Recompile)                  *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFFEXTRL0  IF   E           K DISK    INFSR(*PSSR)
 
     F/COPY WNCPYSRC,FFEXTREF01
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      ** EXTERNAL DS FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Market centre
     D @Market         S              2A
 
 
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
      *
      * INITIALIZE OUTPUTS
      *
     C                   MOVEL     *BLANK        @ERRMS
     C                   MOVEL     *BLANK        @TRRED
      *
      * CHECK FOR USER AUTHORITY TO BROWSE IF NOT MULTI-BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      CHAUTN
     C                   ENDIF
      *
      ** Validate transaction number.
      ** (FOR POINTER)
      *
     C                   EXSR      VALTRN
      *
      * READ FORWARDS
      *
     C     @RDFWD        IFEQ      'Y'
     C                   EXSR      RDFWD
     C                   ELSE
      *
      * READ BACKWARDS
      *
     C     @RDBCK        IFEQ      'Y'
     C                   EXSR      RDBCK
     C                   ENDIF
     C                   ENDIF
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDFWD - READ FORWARDS THROUGH TRANSACTIONS FILE
      *****************************************************************
     C     RDFWD         BEGSR
      *
      * Position to current record on file
      *
     C     @@TNBR        SETGT     FFEXTRL0
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     @@ERR         OREQ      *ZERO
      *
      * Read from transaction file
      *
     C                   READ      FFEXTRL0                               99
      *
      * If multi-branching, check if authorized to look at trade (based
      *  on branch) but if invalid continue searching for valid branch
      *
     C/COPY WNCPYSRC,FFEXTREC01
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C                   ENDIF
     C/COPY WNCPYSRC,FFEXTREC02
      *
     C                   ENDDO
      *
      * If end of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C     FFTNBR        IFEQ      *BLANKS
     C                   MOVEL     'MMM1006'     @ERRMS
     C                   ELSE
     C                   MOVEL     'MMM1002'     @ERRMS
     C                   ENDIF
 
      * Else, return the transaction number and market centre
     C                   ELSE
     C                   MOVE      TNBR          @TRRED
     C                   EVAL      @Market = %subst(ISTT : 1 : 2)
 
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDBCK - READ BACKWARDS THROUGH TRANSACTION AMENDMENTS FILE
      *****************************************************************
     C     RDBCK         BEGSR
      *
      * Position to current record on file
      *
     C     @@TNBR        SETLL     FFEXTRL0
      *
      * Read until end of file or a valid record is found or an error
      *
     C     *IN99         DOUEQ     '1'
     C     @@ERR         OREQ      *ZERO
      *
      * Read previous from transaction file
      *
     C                   READP     FFEXTRL0                               99
      *
      * If multi-branching, check if authorized to look at trade (based
      *  on branch) but if invalid continue searching for valid branch
      *
     C/COPY WNCPYSRC,FFEXTREC03
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    BRCA
     C                   PARM                    @@ERR
     C                   ENDIF
     C/COPY WNCPYSRC,FFEXTREC04
      *
     C                   ENDDO
      *
      * If start of file was encountered, report this fact
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'MMM1003'     @ERRMS
      *
      * Else, return the transaction number and market centre
      *
     C                   ELSE
     C                   MOVE      TNBR          @TRRED
     C                   EVAL      @Market = %subst(ISTT : 1 : 2)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHAUTN - CHECK FOR USER AUTHORITY IF NOT MULTI-BRANCHING
      *****************************************************************
     C     CHAUTN        BEGSR
      *
     C/COPY WNCPYSRC,FFEXTREC05
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    @@ERR             1 0
     C/COPY WNCPYSRC,FFEXTREC06
      *
      * RETURN ERROR MESSAGE
      *
     C     @@ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     @ERRMS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALTRN - VALIDATE TRANSACTION NUMBER
      *****************************************************************
     C     VALTRN        BEGSR
      *
      **  Validate that the transaction number is numeric or blank.
      *
     C                   TESTN                   FFTNBR               98
     C                   MOVE      FFTNBR        @@TEST            1
     C                   TESTZ                   @@TEST                   99
     C     FFTNBR        IFEQ      *BLANKS
     C     *IN98         OREQ      '1'
     C     *IN99         ANDEQ     '1'
     C                   MOVE      FFTNBR        @@TNBR            6 0
      *
      * RETURN ERROR MESSAGE
      *
     C                   ELSE
     C                   MOVEL     'APM0112'     @ERRMS
     C                   RETURN
     C                   ENDIF
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
 
     C     *INZSR        BEGSR
 
 
     C     *entry        PLIST
      * Inputs
      * ------
      * Return code
     C                   PARM                    ReturnCode
      * Transaction number
     C                   PARM                    FFTNBR            6
      * Read forwards
     C                   PARM                    @RDFWD            1
      * Read backwards
     C                   PARM                    @RDBCK            1
      * Bank details
     C                   PARM                    SDBANK
      * Outputs
      * -------
      * Error message
     C                   PARM                    @ERRMS            7
      * Transaction number read
     C                   PARM                    @TRRED            6
      * Market centre of transaction
     C                   PARM                    @Market
     C/COPY WNCPYSRC,FFEXTREC07
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
