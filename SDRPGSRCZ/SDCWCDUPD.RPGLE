     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Compliance watch configuration update')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCWCDUPD - Compliance Watch Configuration Update            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD017             Date 08Nov02               *
      *  Prev Amend No. CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD017 - Midas Compliance Watch - Anti-Money Laundering      *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCWCDL0  UF A E             DISK    COMMIT
      ** Compliance Watch Configuration Data File
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
 
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
 
     D ValidCWCD     E DS                  EXTNAME(SDCWCMPD)
      ** Validated Compliance Watch Configuration Data Definition File
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRTCD           S              7A
     D CSD017          S              1A                                                      CSD017
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main Body                                              *
      *                                                               *
      *****************************************************************
 
      ** Update file
 
     C                   EXSR      SRUPDATE
 
     C                   RETURN
 
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * SRUPDATE - Update File                                       *
      *                                                              *
      ****************************************************************
 
     C     SRUPDATE      BEGSR
 
     C     1             SETLL     SDCWCDL0
     C                   READ      SDCWCDL0
 
     C                   EVAL      W1MDSR = #1MDSR
     C                   EVAL      W1OFSR = #1OFSR
     C                   EVAL      W1CASR = #1CASR
     C                   EVAL      W1CADB = #1CADB
     C                   EVAL      W1CAUS = #1CAUS
     C                   EVAL      W1CAPW = #1CAPW
     C                   EVAL      W1IND1 = #1IND1
     C                   EVAL      W1IND2 = #1IND2
     C                   EVAL      W1IND3 = #1IND3
     C                   EVAL      W1IND4 = #1IND4
     C                   EVAL      W1IND5 = #1IND5
 
     C                   IF        CSD017 = 'Y'                                               CSD017
     C                   EVAL      W1AEIN = #1AEIN                                            CSD017
     C                   EVAL      W1ACCY = #1ACCY                                            CSD017
     C                   EVAL      W1STDI = #1STDI                                            CSD017
     C                   ENDIF                                                                CSD017
                                                                                              CSD017
      ** Update record if not EOF else write to file
 
     C                   IF        %FOUND(SDCWCDL0)
     C                   UPDATE    SDCWCDD0
     C                   ELSE
     C                   WRITE     SDCWCDD0
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
 
      ** Program Parameters
 
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    PRTCD
      ** Validated Compliance Watch Configuration Data Definition File
     C                   PARM                    ValidCWCD
      ** AML Indicator                                                                        CSD017
     C                   PARM                    CSD017                                       CSD017
 
     C                   ENDSR
 
      *****************************************************************
