     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Compliance watch configuration validation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCWCDVAL - Compliance Watch Configuration Validation        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD017             Date 08Nov02               *
      *                 CSD015   *CREATE   Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
     D INDC            S              3A   DIM(5)
     D VINDC           S              3A   DIM(5)
 
     D CWCDDets      E DS                  EXTNAME(SDCWCMPD)
      ** Compliance Watch Configuration Data Definition File
 
     D OKCWCDDets    E DS                  EXTNAME(SDECWCMPD)
      ** Compliance Watch Configuration Data Error File
 
     D ValidCWCD     E DS                  EXTNAME(SDCWCMPD)
     D                                     PREFIX(V)
 
     D SDINDS        E DS                  EXTNAME(SDINDSPD)
      ** External DS for Industry Codes
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  CSD017
      ** External DS for Currency Codes                                                       CSD017
                                                                                              CSD017
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short DS for Access Programs
                                                                                              CSD017
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSD017
      ** Long DS for Access Programs                                                          CSD017
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
     D A               S              3P 0
     D B               S              3P 0
     D POPTN           S              7A
     D PRTCD           S              7A
     D PINDC           S              3A
     D INDCErr         S              1A
     D WIndCode        S              3A
     D CSD017          S              1A                                                      CSD017
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
     C                   EVAL      V#1CAUS = #1CAUS
     C                   EVAL      V#1CAPW = #1CAPW
 
      ** Validate Midas Machine Identifier
 
     C                   EXSR      ValMDSR
     C                   EVAL      V#1MDSR = #1MDSR
 
      ** Validate OFAC-Agent Server Identifier
 
     C                   EXSR      ValOFSR
     C                   EVAL      V#1OFSR = #1OFSR
 
      ** Validate Compliance Alert Server Identifier
 
     C                   EXSR      ValCASR
     C                   IF        #1CASROK = 'Y'
     C                   EVAL      V#1CASR = #1CASR
     C                   ENDIF
 
      ** Validate Compliance Alert Database Name
 
     C                   EXSR      ValCADB
     C                   IF        #1CADBOK = 'Y'
     C                   EVAL      V#1CADB = #1CADB
     C                   ENDIF
 
     C                   IF        #1IND1 <> *BLANKS or #1IND2 <> *BLANKS or
     C                             #1IND3 <> *BLANKS or #1IND4 <> *BLANKS or
     C                             #1IND5 <> *BLANKS
 
      ** Validate Private Customer Industry Code
 
     C                   EXSR      ValINDC
     C                   IF        INDCErr = 'N'
     C                   EVAL      V#1IND1 = #1IND1
     C                   EVAL      V#1IND2 = #1IND2
     C                   EVAL      V#1IND3 = #1IND3
     C                   EVAL      V#1IND4 = #1IND4
     C                   EVAL      V#1IND5 = #1IND5
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        CSD017 = 'Y'                                               CSD017
                                                                                              CSD017
     C                   EVAL      V#1STDI = #1STDI                                           CSD017
                                                                                              CSD017
      ** Validate Account Export Indicator                                                    CSD017
                                                                                              CSD017
     C                   EXSR      ValAEIN                                                    CSD017
     C                   IF        #1AEINOK = 'Y'                                             CSD017
     C                   EVAL      V#1AEIN = #1AEIN                                           CSD017
     C                   ENDIF                                                                CSD017
                                                                                              CSD017
      ** Validate AML Analysis Currency                                                       CSD017
                                                                                              CSD017
     C                   EXSR      ValACCY                                                    CSD017
     C                   IF        #1ACCYOK = 'Y'                                             CSD017
     C                   EVAL      V#1ACCY = #1ACCY                                           CSD017
     C                   ENDIF                                                                CSD017
                                                                                              CSD017
     C                   ENDIF                                                                CSD017
                                                                                              CSD017
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValMDSR - Validate Midas Machine Identifier                   *
      *                                                               *
      *****************************************************************
 
     C     ValMDSR       BEGSR
 
     C                   IF        #1MDSR = *BLANKS
     C                   EVAL      #1MDSR = 'localhost'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValOFSR - Validate OFAC-Agent Server Identifier               *
      *                                                               *
      *****************************************************************
 
     C     ValOFSR       BEGSR
 
     C                   IF        #1OFSR = *BLANKS
     C                   EVAL      #1OFSR = 'fircoof'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValCASR - Validate Compliance Alert Server Identifier         *
      *                                                               *
      *****************************************************************
 
     C     ValCASR       BEGSR
 
     C                   IF        #1CASR = *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1CASR'
     C                   EVAL      MsgIDArr(Idx) = 'USR9406'
     C                   EVAL      #1CASROK = 'N'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValCADB - Validate Compliance Alert Database Name             *
      *                                                               *
      *****************************************************************
 
     C     ValCADB       BEGSR
 
     C                   IF        #1CADB = *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = '#1CADB'
     C                   EVAL      MsgIDArr(Idx) = 'USR9407'
     C                   EVAL      #1CADBOK = 'N'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValINDC - Validate Private Customer Industry Codes            *
      *                                                               *
      *****************************************************************
 
     C     ValINDC       BEGSR
 
     C                   EVAL      VINDC = *BLANKS
 
      ** Move screen field data to array
 
     C                   EVAL      INDC(1) = #1IND1
     C                   EVAL      INDC(2) = #1IND2
     C                   EVAL      INDC(3) = #1IND3
     C                   EVAL      INDC(4) = #1IND4
     C                   EVAL      INDC(5) = #1IND5
 
     C                   EVAL      A = 1
     C                   EVAL      INDCErr = 'N'
 
     C                   DOW       A <= 5
 
      ** Check if valid local industry code
 
     C                   IF        INDC(A) <> *BLANKS
 
     C                   CALL      'AOINDSR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      INDC(A)       PINDC
     C     SDINDS        PARM      SDINDS        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      MsgIDArr(Idx) = 'USR9408'
     C                   EXSR      SRSelFld
     C                   EVAL      INDCErr = 'Y'
     C                   ELSE
     C                   EVAL      INDC(A) = AOLICD
     C                   SELECT
     C                   WHEN      A = 1
     C                   EVAL      #1IND1 = INDC(A)
     C                   WHEN      A = 2
     C                   EVAL      #1IND2 = INDC(A)
     C                   WHEN      A = 3
     C                   EVAL      #1IND3 = INDC(A)
     C                   WHEN      A = 4
     C                   EVAL      #1IND4 = INDC(A)
     C                   WHEN      A = 5
     C                   EVAL      #1IND5 = INDC(A)
     C                   ENDSL
     C                   EVAL      WIndCode = INDC(A)
     C                   ENDIF
 
      ** Check if unique
 
     C                   IF        INDCErr <> 'Y'
 
     C                   EVAL      B = 1
 
     C                   DOW       B <= 5
 
     C                   IF        VINDC(B) = *BLANKS
     C                   EVAL      VINDC(B) = WIndCode
     C                   LEAVE
     C                   ELSE
     C                   IF        VINDC(B) = WIndCode
     C                   ADD       1             Idx
     C                   EVAL      MsgIDArr(Idx) = 'USR9630'
     C                   EXSR      SRSelFld
     C                   EVAL      INDCErr = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      B = B + 1
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      A = A + 1
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************                       CSD017
      /EJECT                                                                                  CSD017
      *****************************************************************                       CSD017
      *                                                               *                       CSD017
      * ValAEIN - Validate Account Export Indicator                   *                       CSD017
      *                                                               *                       CSD017
      *****************************************************************                       CSD017
                                                                                              CSD017
     C     ValAEIN       BEGSR                                                                CSD017
                                                                                              CSD017
     C                   IF        #1AEIN = *BLANKS                                           CSD017
     C                   ADD       1             Idx                                          CSD017
     C                   EVAL      FldNameArr(Idx) = '#1AEIN'                                 CSD017
     C                   EVAL      MsgIDArr(Idx) = 'USR9651'                                  CSD017
     C                   EVAL      #1AEINOK = 'N'                                             CSD017
     C                   ELSE                                                                 CSD017
     C                   IF        #1AEIN <> 'A' AND #1AEIN <> 'C'                            CSD017
     C                   ADD       1             Idx                                          CSD017
     C                   EVAL      FldNameArr(Idx) = '#1AEIN'                                 CSD017
     C                   EVAL      MsgIDArr(Idx) = 'USR9652'                                  CSD017
     C                   EVAL      #1AEINOK = 'N'                                             CSD017
     C                   ENDIF                                                                CSD017
                                                                                              CSD017
     C                   ENDIF                                                                CSD017
                                                                                              CSD017
     C                   ENDSR                                                                CSD017
                                                                                              CSD017
      *****************************************************************                       CSD017
      /EJECT                                                                                  CSD017
      *****************************************************************                       CSD017
      *                                                               *                       CSD017
      * ValACCY - Validate AML Analysis Currency                      *                       CSD017
      *                                                               *                       CSD017
      *****************************************************************                       CSD017
                                                                                              CSD017
     C     ValACCY       BEGSR                                                                CSD017
                                                                                              CSD017
     C                   IF        #1ACCY = *BLANKS                                           CSD017
     C                   ADD       1             Idx                                          CSD017
     C                   EVAL      FldNameArr(Idx) = '#1ACCY'                                 CSD017
     C                   EVAL      MsgIDArr(Idx) = 'USR9653'                                  CSD017
     C                   EVAL      #1ACCYOK = 'N'                                             CSD017
     C                   ELSE                                                                 CSD017
                                                                                              CSD017
      ** Access currency details to check if currency is a valid dealing currency             CSD017
                                                                                              CSD017
     C                   CALL      'AOCURRR0'                                                 CSD017
     C                   PARM      *BLANKS       PRTCD                                        CSD017
     C                   PARM      '*KEY   '     POPTN                                        CSD017
     C                   PARM                    #1ACCY                                       CSD017
     C     SDCURR        PARM      SDCURR        DSSDY                                        CSD017
                                                                                              CSD017
     C                   IF        PRTCD <> *BLANKS OR                                        CSD017
     C                             (PRTCD = *BLANKS AND A6DLCI <> 'Y')                        CSD017
     C                   ADD       1             Idx                                          CSD017
     C                   EVAL      FldNameArr(Idx) = '#1ACCY'                                 CSD017
     C                   EVAL      MsgIDArr(Idx) = 'USR9654'                                  CSD017
     C                   EVAL      #1ACCYOK = 'N'                                             CSD017
     C                   ENDIF                                                                CSD017
                                                                                              CSD017
     C                   ENDIF                                                                CSD017
                                                                                              CSD017
     C                   ENDSR                                                                CSD017
                                                                                              CSD017
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSelFld - Update Field Name Array and Error Flags            *
      *                                                               *
      *****************************************************************
 
     C     SRSelFld      BEGSR
 
     C                   SELECT
     C                   WHEN      A = 1
     C                   EVAL      FldNameArr(Idx) = '#1IND1'
     C                   EVAL      #1IND1OK = 'N'
     C                   WHEN      A = 2
     C                   EVAL      FldNameArr(Idx) = '#1IND2'
     C                   EVAL      #1IND2OK = 'N'
     C                   WHEN      A = 3
     C                   EVAL      FldNameArr(Idx) = '#1IND3'
     C                   EVAL      #1IND3OK = 'N'
     C                   WHEN      A = 4
     C                   EVAL      FldNameArr(Idx) = '#1IND4'
     C                   EVAL      #1IND4OK = 'N'
     C                   WHEN      A = 5
     C                   EVAL      FldNameArr(Idx) = '#1IND5'
     C                   EVAL      #1IND5OK = 'N'
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset Error Information That Is Received Back     *
      *             From Each Validation Module                       *
      *                                                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *BLANKS
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIDArr = *BLANKS
     C                   EVAL      MsgDtaArr = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Compliance Watch Configuration Data Definition File
     C                   PARM                    CWCDDets
      ** AML Indicator                                                                        CSD017
     C                   PARM                    CSD017                                       CSD017
 
      ** Outputs
      ** Compliance Watch Configuration Data Error File
     C                   PARM                    OKCWCDDets
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Validated Compliance Watch Configuration Data Definition File
     C                   PARM                    ValidCWCD
 
     C                   EVAL      DBPGM = 'SDCWCDVAL'
 
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
