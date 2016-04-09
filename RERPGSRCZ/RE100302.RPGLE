     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Zero Balancing/Sweeping Header Validation')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100302 - Zero Balancing/Sweeping Header Validation         *
      *                                                               *
      *  Function:  This program validates the 'front end'            *
      *             zero balancing/sweeping header.                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD000091           Date 14May13               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 214360             Date 03Feb03               *
      *                 212467             Date 10Jan03               *
      *                 212122             Date 09Dec02               *
      *                 212121             Date 09Dec02               *
      *                 211464             Date 03Dec02               *
      *                 CRE008  *CREATE    Date 06Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  214360 - Cash Management Deferred Posting                    *
      *  212467 - External Forward and Back Value Sweeping details    *
      *           must be constrained by the ICD.                     *
      *  212122 - MT103 & MT101 charges a/c's can be in any currency  *
      *  212121 - MT103 instruction code can be blank                 *
      *  211464 - SWIFT address not accepted                          *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(ACCNTABF)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
     D O_PACD          S             10  0                                                    CGL029
     D I_C1ACCID       S             24                                                       CGL029
     D I_C3ACCID       S             24                                                       CGL029
     D BlankAC         S             24                                                       CGL029
 
     D S_ICSF          S              4    DIM(12)
 
 
     D                 DS
     D NumPer                  1      3
     D Number                  1      2
     D Period                  3      3
 
 
     D                 DS
     D**ACCCID**                 1     18                                                     CGL029
     D ACCID                   1     24                                                       CGL029
     D BRC                     1      3
     D*CUS******               4      9S 0                                                    CSD027
     D CUS                     4      9A                                                      CSD027
     D CCY                    10     12
     D***ACD****                13     16S 0                                                  CGL029
     D***ASN****                17     18S 0                                                  CGL029
     D ACD                    13     22S 0                                                    CGL029
     D ASN                    23     24S 0                                                    CGL029
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
     D SDCMAN        E DS                  EXTNAME(SDCMANPD)
      ** External DS for cash management details
     D SDRETR        E DS                  EXTNAME(SDRETRPD)
      ** Retail Transaction Type Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer Details
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      ** Counter Party Nostro
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      ** BIC Directory
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs
 
 
      /SPACE 5
 
 
      * Clear outputs
 
     C                   Z-ADD     *ZERO         O_CAM1
     C                   Z-ADD     *ZERO         O_CAM3
 
      * Access currency details
 
     C                   MOVEL     I_CCCY        CCY
     C                   EXSR      ACS_CURR
 
      * Validate Input Cycle Sweeping Frequency
 
     C                   EXSR      VAL_ICSF
 
      * Validate Sweeping Holiday Convention
 
     C                   EXSR      VAL_SHOC
 
      *  Validate Transaction Type - Top
 
     C                   EXSR      VAL_TYPT
 
      *  Validate Transaction Type - Sweep
 
     C                   EXSR      VAL_TYPS
 
      * Validate Check For Cover on Top A/c
 
     C                   EXSR      VAL_CHKC
 
      * Validate External indicator
 
     C                   EXSR      VAL_EXTL
 
      * Validate Master Account indicator
 
     C                   EXSR      VAL_MAST
 
      * If external = 'Y'
      * or master account = 'Y'
      * or if destination a/c defined
 
     C     I_SEXTL       IFEQ      'Y'
     C     I_SMAST       OREQ      'Y'
     C     I_SDEST       ORNE      *BLANK
 
      *  Validate External Narrative
 
     C                   EXSR      VAL_ENAR
 
      *  Validate External Forward Value Sweeping
 
     C                   EXSR      VAL_EFVS
 
      *  Validate External Forward Value Days
 
     C     I_SEFVD       IFNE      '   '
     C     I_SEFVD       ANDNE     '00 '
     C                   EXSR      VAL_EFVD
     C                   ENDIF
 
      *  Validate External Back Value Days
 
     C     I_SEBVD       IFNE      '   '
     C     I_SEBVD       ANDNE     '00 '
     C                   EXSR      VAL_EBVD
     C                   ENDIF
 
      *  Validate Destination a/c
 
     C                   EXSR      VAL_DESTAC
 
      *  Validate Receiver's Correspondent
 
     C     I_SRCVC       IFNE      *BLANK
     C                   EXSR      VAL_RCVC
     C                   ENDIF
 
      *  Validate Cover Message Required
 
     C                   EXSR      VAL_MCMR
 
      *  Validate MT103 Value Date Offset
 
     C                   EXSR      VAL_MVDO
 
      *  Validate MT101 Charges (code)
 
     C                   EXSR      VAL_CHG1
 
      *  Validate MT101 Charges Account
 
     C                   EXSR      VAL_C1ACCID
 
      *  Validate MT101 Charges Amount
 
     C                   EXSR      VAL_CAM1
 
      *  Validate MT101 Instruction Code
 
     C                   EXSR      VAL_ICD1
 
      *  Validate MT103 Charges (code)
 
     C                   EXSR      VAL_CHG3
 
      *  Validate MT103 Charges Account
 
     C                   EXSR      VAL_C3ACCID
 
      *  Validate MT103 Charges Amount
 
     C                   EXSR      VAL_CAM3
 
      *  Validate MT103 Instruction Code
 
     C                   EXSR      VAL_ICD3
 
      *  Validate MT103 Bank Operation Code
 
     C                   EXSR      VAL_BOCD
 
      *  Validate External Account 1-5
 
     C                   EXSR      VAL_EXA
                                                                                214360
      * Deferred Posting                                                        214360
                                                                                214360
     C                   EXSR      VAL_DEFP                                     214360
                                                                                214360
      * Deferred Posting Zero Narrative                                         214360
                                                                                214360
     C                   EXSR      VAL_DEFZ                                     214360
     C                   ENDIF
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Validate Input Cycle Sweeping Frequency
      ********************************************************************
     C     VAL_ICSF      BEGSR
 
     C     I_SICSF       IFNE      'ALL  '
     C     I_SICSF       ANDNE     'NEVER'
 
     C                   Z-ADD     1             X                 2 0
     C                   Z-ADD     1             Y                 2 0
     C     X             DOUEQ     49
     C     4             SUBST     I_SICSF:X     W_TIME            4
     C                   ADD       4             X
 
     C     W_TIME        IFNE      *BLANK
     C     W_TIME        LOOKUP    S_ICSF                                 99    *
 
      * 'Invalid Input Cycle Sweeping Frequency Time'
 
     C     *IN99         IFEQ      '0'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHICSF   '   FldNameArr(Ix)
     C                   MOVEL     'RE75210'     MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   LEAVE
 
     C                   ELSE
 
     C     1             SUBST     I_SICSI:Y     W_INDC            1
     C                   ADD       1             Y
 
      * 'Invalid Input Cycle Sweeping Indicator' (BOTH, SWEEP, TOP)
 
     C     W_INDC        IFNE      'B'
     C     W_INDC        ANDNE     'S'
     C     W_INDC        ANDNE     'T'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHICSI   '   FldNameArr(Ix)
     C                   MOVEL     'RE75211'     MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Sweeping Holiday Convention
      ********************************************************************
     C     VAL_SHOC      BEGSR
 
      * 'Holiday convention must be I = INCLUDE or E = EXCLUDE'
 
     C     I_SSHOC       IFNE      'I'
     C     I_SSHOC       ANDNE     'E'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHSHOC   '   FldNameArr(Ix)
     C                   MOVEL     'RE75212 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Transaction Type - Top
      ********************************************************************
     C     VAL_TYPT      BEGSR
 
      * 'Invalid Transaction Type - Top'
 
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      I_STYPT       @TRATT            5
     C     SDRETR        PARM      SDRETR        DSFDY
 
     C     @RTCD         IFNE      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHTYPT   '   FldNameArr(Ix)
     C                   MOVEL     'RE75213'     MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Transaction Type - Sweep
      ********************************************************************
     C     VAL_TYPS      BEGSR
 
      * 'Invalid Transaction Type - Sweep'
 
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      I_STYPS       @TRATT
     C     SDRETR        PARM      SDRETR        DSFDY
 
     C     @RTCD         IFNE      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHTYPS   '   FldNameArr(Ix)
     C                   MOVEL     'RE75214'     MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Check For Cover on Top A/c
      ********************************************************************
     C     VAL_CHKC      BEGSR
 
      * 'Check For Cover on Top Account must be Y or N'
 
     C     I_SCHKC       IFNE      'Y'
     C     I_SCHKC       ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHCHKC   '   FldNameArr(Ix)
     C                   MOVEL     'RE75215 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate External indicator
      ********************************************************************
     C     VAL_EXTL      BEGSR
 
      * 'External indicator must be Y or N'
 
     C     I_SEXTL       IFNE      'Y'
     C     I_SEXTL       ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHEXTL   '   FldNameArr(Ix)
     C                   MOVEL     'RE75216 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Master Account indicator
      ********************************************************************
     C     VAL_MAST      BEGSR
 
      * 'Master account indicator must be Y or N'
 
     C     I_SMAST       IFNE      'Y'
     C     I_SMAST       ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHMAST   '   FldNameArr(Ix)
     C                   MOVEL     'RE75236 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
      * 'If Master account indicator is Y, the external indicator must be Y'
 
     C     I_SMAST       IFEQ      'Y'
     C     I_SEXTL       ANDNE     'Y'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHMAST   '   FldNameArr(Ix)
     C                   MOVEL     'RE75237 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate External Narrative
      ********************************************************************
     C     VAL_ENAR      BEGSR
 
      * 'External narrative must be defined'
 
     C     I_SENAR       IFEQ      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHENAR   '   FldNameArr(Ix)
     C                   MOVEL     'RE75217 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate External Forward Value Sweeping
      ********************************************************************
     C     VAL_EFVS      BEGSR
 
      * Default
     C     I_SEFVS       IFEQ      ' '
     C                   MOVEL     'N'           I_SEFVS
     C                   ENDIF
 
      * 'External forward value sweeping must be Y or N'
 
     C     I_SEFVS       IFNE      'Y'
     C     I_SEFVS       ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHEFVS   '   FldNameArr(Ix)
     C                   MOVEL     'RE75218 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate External Forward Value Days
      ********************************************************************
     C     VAL_EFVD      BEGSR
 
     C                   MOVEL     I_SEFVD       NumPer
 
      * 'External forward value days must be a number followed by C or B'
 
     C     Period        IFNE      'C'
     C     Period        ANDNE     'B'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHEFVD   '   FldNameArr(Ix)
     C                   MOVEL     'RE75219 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
     C                   TESTN                   Number               9798
     C     *IN97         IFEQ      '0'
     C     *IN98         ANDEQ     '0'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHEFVD   '   FldNameArr(Ix)
     C                   MOVEL     'RE75219 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE                                                   212467
                                                                                212467
      * 'External forward value days must not exceed the ICD days               212467
                                                                                212467
     C                   EXSR      CAL_NOOFDAYS                                 212467
     C     NoOfDays      IFGT      Fwd_NoOfDays                                 212467
     C                   EXSR      CHK_4RETURN                                  212467
     C                   ADD       1             Ix                             212467
     C                   MOVEL     'ZHEFVD   '   FldNameArr(Ix)                 212467
     C                   MOVEL     'RE75238 '    MsgIDArr(Ix)                   212467
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                       212467 MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF                                                  212467
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate External Back Value Days
      ********************************************************************
     C     VAL_EBVD      BEGSR
 
     C                   MOVEL     I_SEBVD       NumPer
 
      * 'External back value days/months must be a number followed by C B or M'
 
     C     Period        IFNE      'C'
     C     Period        ANDNE     'B'
     C     Period        ANDNE     'M'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHEBVD   '   FldNameArr(Ix)
     C                   MOVEL     'RE75220 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
     C                   TESTN                   Number               9798
     C     *IN97         IFEQ      '0'
     C     *IN98         ANDEQ     '0'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHEBVD   '   FldNameArr(Ix)
     C                   MOVEL     'RE75220 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE                                                   212467
                                                                                212467
      * 'External back value days/months must not exceed the ICD days/months    212467
                                                                                212467
     C                   EXSR      CAL_NOOFDAYS                                 212467
     C     NoOfDays      IFGT      Bck_NoOfDays                                 212467
     C                   EXSR      CHK_4RETURN                                  212467
     C                   ADD       1             Ix                             212467
     C                   MOVEL     'ZHEBVD   '   FldNameArr(Ix)                 212467
     C                   MOVEL     'RE75239 '    MsgIDArr(Ix)                   212467
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                       212467 MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF                                                  212467
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Destination A/c
      ********************************************************************
     C     VAL_DESTAC    BEGSR
 
     C                   CALLB     'REZDESTAC'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
      * Hierarchy ID
      * Child currency
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_CCCY            3
      * Destination
      * Destination Type
      * Sender's Correspondent
     C                   PARM                    I_SDEST          18
     C                   PARM                    I_SDSTT           1
     C                   PARM                    I_SSNDC           2
 
      * OUTPUTS
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   PARM                    O_PBRC            3
     C**********         PARM                    O_PCUS            6 0                        CSD027
     C                   PARM                    O_PCUS            6                          CSD027
     C                   PARM                    O_PCCY            3
     C**********         PARM                    O_PACD            4 0                        CGL029
     C                   PARM                    O_PACD                                       CGL029
     C                   PARM                    O_PASN            2 0
      * Parent retail no.
      * Parent a/c profit centre
      * Parent a/c account section
      * Parent a/c account type
     C                   PARM                    O_PRNO           10 0
     C                   PARM                    O_PPRF            4
     C                   PARM                    O_PACS            2
     C                   PARM                    O_PATY            1
      * Parent a/c status
     C                   PARM                    O_ParentSTAT     26
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN DESTINATION A/C:'
     C                                      + I_SDEST + I_SDSTT
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate Receiver's Correspondent
      ********************************************************************
     C     VAL_RCVC      BEGSR
 
     C     8             SUBST     I_SRCVC:1     W9BICC
     C     3             SUBST     I_SRCVC:9     W9BICB
 
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       W9RTN             7
     C                   PARM                    W9BICC            8
     C                   PARM                    W9BICB            3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       W9CUST            1
     C                   PARM      *BLANKS       W9CNST            1
     C                   PARM      *BLANKS       W9BICD            1
 
      * 'Receivers Correspondent is not a valid SWIFT BIC code'
 
     C     W9BICD        IFNE      'Y'
     C     W9CUST        ANDNE     'Y'                                          211464
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHRCVC   '   FldNameArr(Ix)
     C                   MOVEL     'RE75234 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate Cover Message Required
      ********************************************************************
     C     VAL_MCMR      BEGSR
 
      * 'Cover message required must be Y or N'
 
     C     I_SMCMR       IFNE      'Y'
     C     I_SMCMR       ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHMCMR   '   FldNameArr(Ix)
     C                   MOVEL     'RE75221 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
      * 'If cover message is required, senders correspondent must be defined'
 
     C     I_SMCMR       IFEQ      'Y'
     C     I_SSNDC       ANDEQ     *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHMCMR   '   FldNameArr(Ix)
     C                   MOVEL     'RE75235 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate MT103 Value Date Offset
      ********************************************************************
     C     VAL_MVDO      BEGSR
 
      * 'MT103 value date offset must be 0, 1, or 2 days'
 
     C     I_SMVDO       IFNE      '0'
     C     I_SMVDO       ANDNE     '1'
     C     I_SMVDO       ANDNE     '2'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHMVDO   '   FldNameArr(Ix)
     C                   MOVEL     'RE75222 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate MT101 Charges (code)
      ********************************************************************
     C     VAL_CHG1      BEGSR
 
      * 'MT101 charges code must be OUR, BEN, SHA or blank'
 
     C     I_SCHG1       IFNE      'OUR'
     C     I_SCHG1       ANDNE     'BEN'
     C     I_SCHG1       ANDNE     'SHA'
     C     I_SCHG1       ANDNE     '   '
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHCHG1   '   FldNameArr(Ix)
     C                   MOVEL     'RE75223 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate MT101 Charges Account
      ********************************************************************
     C     VAL_C1ACCID   BEGSR
 
      * 'Invalid MT101 Charges Account'
 
     C                   MOVEL     I_C1ACCID     ACCID
     C     ACCID         IFNE      BlankAC
     C     ACCID         ANDNE     *BLANK
     C                   EXSR      ACS_ACCNT
     C     *IN60         IFEQ      '1'
     C     RECI          ORNE      'D'
     C*****CCY***********ORNE      I_CCCY                                       212122
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHCAC1    '  FldNameArr(Ix)
     C                   MOVEL     'RE75224'     MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate MT101 Charges Amount
      ********************************************************************
     C     VAL_CAM1      BEGSR
 
      * 'Invalid MT101 Charge Amount'
 
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      I_SCAM1       ZFLD17
     C     15            SUB       A6NBDP        ZSDIG
     C                   Z-ADD     A6NBDP        ZSDEC
 
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHCAM1   '   FldNameArr(Ix)
     C                   MOVEL     'RE75225'     MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
     C                   MOVE      ZOUT15        O_CAM1
     C     ZFSIGN        IFEQ      '-'
     C     I_C1ACCID     ORNE      BlankAC
     C     I_C1ACCID     ANDNE     *BLANK
     C     O_CAM1        ANDEQ     *ZERO
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHCAM1   '   FldNameArr(Ix)
     C                   MOVEL     'RE75225'     MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   END
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate MT101 Instruction Code
      ********************************************************************
     C     VAL_ICD1      BEGSR
 
      * 'MT101 Instruction Code must be CMSW, CMTO, or CMZB'
     C/COPY WNCPYSRC,REH00055
 
     C     I_SICD1       IFNE      'CMSW'
     C     I_SICD1       ANDNE     'CMTO'
     C     I_SICD1       ANDNE     'CMZB'
     C/COPY WNCPYSRC,REH00056
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHICD1   '   FldNameArr(Ix)
     C/COPY WNCPYSRC,REH00058
     C                   MOVEL     'RE75226 '    MsgIDArr(Ix)
     C/COPY WNCPYSRC,REH00057
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate MT103 Charges (code)
      ********************************************************************
     C     VAL_CHG3      BEGSR
 
      * 'MT103 charges code must be OUR, BEN, SHA or blank'
 
     C     I_SCHG3       IFNE      'OUR'
     C     I_SCHG3       ANDNE     'BEN'
     C     I_SCHG3       ANDNE     'SHA'
     C     I_SCHG3       ANDNE     '   '
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHCHG3   '   FldNameArr(Ix)
     C                   MOVEL     'RE75227 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate MT103 Charges Account
      ********************************************************************
     C     VAL_C3ACCID   BEGSR
 
      * 'Invalid MT103 Charges Account'
 
     C                   MOVEL     I_C3ACCID     ACCID
     C     ACCID         IFNE      BlankAC
     C     ACCID         ANDNE     *BLANK
     C                   EXSR      ACS_ACCNT
     C     *IN60         IFEQ      '1'
     C     RECI          ORNE      'D'
     C*****CCY***********ORNE      I_CCCY                                       212122
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHCAC3    '  FldNameArr(Ix)
     C                   MOVEL     'RE75228'     MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate MT103 Charges Amount
      ********************************************************************
     C     VAL_CAM3      BEGSR
 
      * 'Invalid MT103 Charge Amount'
 
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      I_SCAM3       ZFLD17
     C     15            SUB       A6NBDP        ZSDIG
     C                   Z-ADD     A6NBDP        ZSDEC
 
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHCAM3   '   FldNameArr(Ix)
     C                   MOVEL     'RE75229'     MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
     C                   MOVE      ZOUT15        O_CAM3
     C     ZFSIGN        IFEQ      '-'
     C     I_C3ACCID     ORNE      BlankAC
     C     I_C3ACCID     ANDNE     *BLANK
     C     O_CAM3        ANDEQ     *ZERO
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHCAM3   '   FldNameArr(Ix)
     C                   MOVEL     'RE75229'     MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   END
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate MT103 Instruction Code
      ********************************************************************
     C     VAL_ICD3      BEGSR
 
      * 'MT103 Instruction Code must be SDVA, INTC, CORT, BONL ..'
 
     C     I_SICD3       IFNE      'SDVA'
     C     I_SICD3       ANDNE     'INTC'
     C     I_SICD3       ANDNE     'CORT'
     C     I_SICD3       ANDNE     'BONL'
     C     I_SICD3       ANDNE     'HOLD'
     C     I_SICD3       ANDNE     'CHQB'
     C     I_SICD3       ANDNE     'PHOB'
     C     I_SICD3       ANDNE     'TELB'
     C     I_SICD3       ANDNE     'PHON'
     C     I_SICD3       ANDNE     'TELE'
     C     I_SICD3       ANDNE     'PHOI'
     C     I_SICD3       ANDNE     'TELI'
     C     I_SICD3       ANDNE     '    '                                       212121
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHICD3   '   FldNameArr(Ix)
     C                   MOVEL     'RE75230 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate MT103 Bank Operation Code
      ********************************************************************
     C     VAL_BOCD      BEGSR
 
      * 'MT103 Bank Operation Code must be CRED, SPAY, SPRI or SSTD'
 
     C     I_SBOCD       IFNE      'CRED'
     C     I_SBOCD       ANDNE     'SPAY'
     C     I_SBOCD       ANDNE     'SPRI'
     C     I_SBOCD       ANDNE     'SSTD'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHBOCD   '   FldNameArr(Ix)
     C                   MOVEL     'RE75231 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate External Account 1-5
      ********************************************************************
     C     VAL_EXA       BEGSR
 
      * 'First line of the external account must start with /'
 
     C                   MOVEL     I_SEXA1       StartofLine       1
     C     StartofLine   IFNE      '/'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHEXA1   '   FldNameArr(Ix)
     C                   MOVEL     'RE75232 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
      * 'Second line of the external account must be defined'
 
     C     I_SEXA2       IFEQ      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZHEXA2   '   FldNameArr(Ix)
     C                   MOVEL     'RE75233 '    MsgIDArr(Ix)
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5                                                                  214360
      ********************************************************************      214360
      *  Validate Deferred Posting                                              214360
      ********************************************************************      214360
     C     VAL_DEFP      BEGSR                                                  214360
                                                                                214360
      * 'Deferred Posting must be Y or N'                                       214360
                                                                                214360
     C     I_SDEFP       IFNE      'Y'                                          214360
     C     I_SDEFP       ANDNE     'N'                                          214360
     C                   EXSR      CHK_4RETURN                                  214360
     C                   ADD       1             Ix                             214360
     C                   MOVEL     'ZHDEFP   '   FldNameArr(Ix)                 214360
     C                   MOVEL     'RE75245 '    MsgIDArr(Ix)                   214360
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                       214360 MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE                                                   214360
                                                                                214360
      * 'Deferred Posting cant be Y if this is a master account hierarchy'      214360
                                                                                214360
     C     I_SDEFP       IFEQ      'Y'                                          214360
     C     I_SMAST       ANDEQ     'Y'                                          214360
     C                   EXSR      CHK_4RETURN                                  214360
     C                   ADD       1             Ix                             214360
     C                   MOVEL     'ZHDEFP   '   FldNameArr(Ix)                 214360
     C                   MOVEL     'RE75246 '    MsgIDArr(Ix)                   214360
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                       214360 MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF                                                  214360
     C                   ENDIF                                                  214360
                                                                                214360
     C                   ENDSR                                                  214360
      *********************************************************************     214360
      /SPACE 5                                                                  214360
      ********************************************************************      214360
      *  Validate Deferred Posting Zero Narrative                               214360
      ********************************************************************      214360
     C     VAL_DEFZ      BEGSR                                                  214360
                                                                                214360
      * 'Deferred Posting Zero Narrative must be Y or N'                        214360
                                                                                214360
     C     I_SDEFZ       IFNE      'Y'                                          214360
     C     I_SDEFZ       ANDNE     'N'                                          214360
     C                   EXSR      CHK_4RETURN                                  214360
     C                   ADD       1             Ix                             214360
     C                   MOVEL     'ZHDEFZ   '   FldNameArr(Ix)                 214360
     C                   MOVEL     'RE75247 '    MsgIDArr(Ix)                   214360
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                       214360 MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE                                                   214360
                                                                                214360
      * 'Deferred Posting Zero Narrative cant be Y if Deferred Posting is N'    214360
                                                                                214360
     C     I_SDEFZ       IFEQ      'Y'                                          214360
     C     I_SDEFP       ANDEQ     'N'                                          214360
     C                   EXSR      CHK_4RETURN                                  214360
     C                   ADD       1             Ix                             214360
     C                   MOVEL     'ZHDEFZ   '   FldNameArr(Ix)                 214360
     C                   MOVEL     'RE75248 '    MsgIDArr(Ix)                   214360
     C**********         MOVEL     I_HIER        MsgDtaArr(Ix)                       214360 MD000091
     C                   MOVEL     I_HIER        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF                                                  214360
     C                   ENDIF                                                  214360
                                                                                214360
     C                   ENDSR                                                  214360
      *********************************************************************     214360
      /SPACE 5
      ********************************************************************
      * Validate & right align signed numeric field
      ********************************************************************
     C     ZASIGN        BEGSR
     C                   CALLB     'ZASIGN'
     C                   PARM                    ZASIGNok          1
     C                   PARM                    ZFLD17           17
     C                   PARM                    ZSDIG             2 0
     C                   PARM                    ZSDEC             1 0
     C                   PARM                    ZSDCSP            1            156689
     C                   PARM                    ZOUT15           15
     C                   PARM                    ZFSIGN            1
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Access a currency
      ********************************************************************
     C     ACS_CURR      BEGSR
 
     C                   CALLB     'ZAACSCURR'
     C                   PARM                    CCY               3
     C                   PARM                    SDCURR
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Access a/c details
      ********************************************************************
     C     ACS_ACCNT     BEGSR
 
     C     ACCNTK        CHAIN     ACCNTABF                           60        *
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Check for Return
      ********************************************************************
     C     CHK_4RETURN   BEGSR
     C     Ix            IFEQ      ArrayMax
     C                   RETURN
     C                   ENDIF
     C                   ENDSR
      *******************************************************************
      /SPACE 5                                                                  212467
      ********************************************************************      212467
      * Calculate number of days                                                212467
      ********************************************************************      212467
     C     CAL_NOOFDAYS  BEGSR                                                  212467
     C                   Z-ADD     *ZERO         NoOfDays          5 0          212467
     C                   MOVE      Number        NoOfDays                       212467
     C     Period        IFEQ      'M'                                          212467
     C                   MULT      30            NoOfDays                       212467
     C                   ENDIF                                                  212467
     C                   ENDSR                                                  212467
      *******************************************************************       212467
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Return code
      * Error Message
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
      * INPUTS
      * Hierarchy ID
      * Child currency
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_CCCY            3
 
      * Input Cycle Sweeping Frequency
      * Input Cycle Sweeping Indicators
     C                   PARM                    I_SICSF          48
     C                   PARM                    I_SICSI          12
 
      * Sweeping Holiday Convention - COB
     C                   PARM                    I_SSHOC           1
 
      * Transaction Type - Top
      * Transaction Type - Sweep
     C                   PARM                    I_STYPT           5
     C                   PARM                    I_STYPS           5
 
      * Check For Cover on Top A/c
     C                   PARM                    I_SCHKC           1
 
      * External
      * Master Account
      * External Narrative
      * External Fwd Value Sweeping
      * External Fwd Value Days
      * External Bck Value Days
     C                   PARM                    I_SEXTL           1
     C                   PARM                    I_SMAST           1
     C                   PARM                    I_SENAR          30
     C                   PARM                    I_SEFVS           1
     C                   PARM                    I_SEFVD           3
     C                   PARM                    I_SEBVD           3
      * Destination
      * Destination Type
      * Sender's Correspondent
      * Receiver's Correspondent
     C                   PARM                    I_SDEST          18
     C                   PARM                    I_SDSTT           1
     C                   PARM                    I_SSNDC           2
     C                   PARM                    I_SRCVC          11
 
      * MT202 Cover Message Required
      * MT103 Value Date Offset
     C                   PARM                    I_SMCMR           1
     C                   PARM                    I_SMVDO           1
 
      * MT101 Charges
      * MT101 Charges Account
      * MT101 Charges Amount
      * MT101 Instruction Code
     C                   PARM                    I_SCHG1           3
     C**********         PARM                    I_C1ACCID        18                          CGL029
     C                   PARM                    I_C1ACCID                                    CGL029
     C                   PARM                    I_SCAM1          17
     C                   PARM                    I_SICD1           4
 
      * MT103 Charges
      * MT103 Charges Account
      * MT103 Charges Amount
      * MT103 Instruction Code
     C                   PARM                    I_SCHG3           3
     C**********         PARM                    I_C3ACCID        18                          CGL029
     C                   PARM                    I_C3ACCID                                    CGL029
     C                   PARM                    I_SCAM3          17
     C                   PARM                    I_SICD3           4
      * MT103 Bank Operation Code
     C                   PARM                    I_SBOCD           4
      * External Account 1-5
     C                   PARM                    I_SEXA1          35
     C                   PARM                    I_SEXA2          35
     C                   PARM                    I_SEXA3          35
     C                   PARM                    I_SEXA4          35
     C                   PARM                    I_SEXA5          35
      * Deferred Posting                                                        214360
      * Deferred Posting Zero Narrative                                         214360
     C                   PARM                    I_SDEFP           1            214360
     C                   PARM                    I_SDEFZ           1            214360
 
      * BANK details
     C                   PARM                    SDBANK
 
      * OUTPUTS
      * MT101 Charges Amount
      * MT103 Charges Amount
     C                   PARM                    O_CAM1           15 0
     C                   PARM                    O_CAM3           15 0
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
     C                   CALLB     'AOCMANR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDCMAN        PARM      SDCMAN        DSSDY
 
      * Database Error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      X_ERMS = 'Call to AOCMANR0 in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEA     CMICSF        S_ICSF
      * Forward-Value                                                           212467
     C                   MOVEL     CMEFVD        NumPer                         212467
     C                   EXSR      CAL_NOOFDAYS                                 212467
     C                   Z-ADD     NoOfDays      Fwd_NoOfDays      5 0          212467
      * Back-Value                                                              212467
     C                   MOVEL     CMEBVD        NumPer                         212467
     C                   EXSR      CAL_NOOFDAYS                                 212467
     C                   Z-ADD     NoOfDays      Bck_NoOfDays      5 0          212467
 
      * Blank A/c
     C**********         Z-ADD     *ZERO         CUS                                          CSD027
     C                   EVAL      CUS =         *BLANKS                                      CSD027
     C                   Z-ADD     *ZERO         ACD
     C                   Z-ADD     *ZERO         ASN
     C**********         MOVEL     ACCID         BlankAC          18                          CGL029
     C                   MOVEL     ACCID         BlankAC                                      CGL029
 
      * key lists
 
     C     ACCNTK        KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
