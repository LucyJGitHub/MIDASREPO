     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Compliance watch configuration convert')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCWCDCVT - Compliance Watch Configuration Convert           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD101             Date 07Dec18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD017             Date 08Nov02               *
      *                 CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD101 - Password Encryption                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD017 - Midas Compliance Watch - Anti-Money Laundering      *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
 
 
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
 
     D CWCDFilFmt    E DS                  EXTNAME(SDCWCDPD)
      ** Compliance Watch Configuration Data in File Format
 
     D CWCDDets      E DS                  EXTNAME(SDCWCMPD)
      ** Compliance Watch Configuration Data Definition File
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D CSD017          S              1A                                                      CSD017
                                                                                              CSD017
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialisation
 
     C                   EXSR      SRINIT
 
      ** Set screen fields
 
     C                   EXSR      SRSCREEN
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSCREEN - Set Screen Fields                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSCREEN      BEGSR
 
     C                   EVAL      #1MDSR = W1MDSR
     C                   EVAL      #1OFSR = W1OFSR
     C                   EVAL      #1CASR = W1CASR
     C                   EVAL      #1CADB = W1CADB
     C                   EVAL      #1CAUS = W1CAUS
     C**********         EVAL      #1CAPW = W1CAPW                                            CSD101
     C                   EVAL      #1IND1 = W1IND1
     C                   EVAL      #1IND2 = W1IND2
     C                   EVAL      #1IND3 = W1IND3
     C                   EVAL      #1IND4 = W1IND4
     C                   EVAL      #1IND5 = W1IND5
 
     C                   IF        CSD017 = 'Y'                                               CSD017
     C                   EVAL      #1AEIN = W1AEIN                                            CSD017
     C                   EVAL      #1ACCY = W1ACCY                                            CSD017
     C                   EVAL      #1STDI = W1STDI                                            CSD017
     C                   ENDIF                                                                CSD017
                                                                                              CSD017
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialisation                                       *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** Blank outputs
 
     C                   MOVEL     *BLANKS       CWCDDets
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Program Parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Compliance Watch Configuration Data in File Format
     C                   PARM                    CWCDFilFmt
      ** AML Indicator                                                                        CSD017
     C                   PARM                    CSD017                                       CSD017
 
      ** Output Parameters
      ** Compliance Watch Configuration Data Definition File
     C                   PARM                    CWCDDets
 
      ** Initialise program name
 
     C                   EVAL      DBPGM = 'SDCWCDCVT'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
