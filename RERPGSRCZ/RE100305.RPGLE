     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Zero Balancing/Sweeping Member Validation')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100305 - Zero Balancing/Sweeping Member Validation         *
      *                                                               *
      *  Function:  This program validates the 'front end'            *
      *             zero balancing/sweeping member.                   *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 14May13               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 216106             Date 07Apr03               *
      *                 214552             Date 03Feb03               *
      *                 212463             Date 10Jan03               *
      *                 CRE008  *CREATE    Date 06Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  216106 - Top a/c sweep freq must be 'D' for deferred posting *
      *  214552 - Input cycle sweeping frequency                      *
      *  212463 - Missing validation of hierarchies                   *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(ACCNTABF)
     FREZSMXL1  IF   E           K DISK    INFSR(*PSSR)                         212463
     F                                     PREFIX(Z_)                           212463
     FREGAMXL1  IF   E           K DISK    INFSR(*PSSR)                         212463
     F                                     PREFIX(G_)                           212463
     F*REZSHLJ2**IF***E***********K*DISK****INFSR(*PSSR)                        212463
     F**************************************PREFIX(Z_)                          212463
     F*REGAHLJ2**IF***E***********K*DISK****INFSR(*PSSR)                        212463
     F**************************************PREFIX(G_)                          212463
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
     D I_SACCID        S             24                                                       CGL029
     D I_IIACID        S             24                                                       CGL029
     D I_IEACID        S             24                                                       CGL029
     D BlankAC         S             24                                                       CGL029
 
      * Account ID
     D                 DS
     D***ACCID**                 1     18                                                     CGL029
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
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for GENERAL LEDGER details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
 
 
      /SPACE 5
 
      * Clear outputs
 
     C                   Z-ADD     *ZERO         O_FSDT
     C                   Z-ADD     *ZERO         O_TGBL
     C                   Z-ADD     *ZERO         O_MINB
     C                   Z-ADD     *ZERO         O_MINL
     C                   Z-ADD     *ZERO         O_MAXB
     C                   Z-ADD     *ZERO         O_MAXL
 
      * Access currency details
 
     C                   MOVEL     I_CCCY        CCY
     C                   EXSR      ACS_CURR
 
      * Validate (Child) Narrative
 
     C                   EXSR      VAL_CNAR
 
      *  Validate Sweep Type
 
     C                   EXSR      VAL_STYP
 
      * If Sweep Type = SWEEP
      *  Validate Sweeping Schedule
 
     C     I_SSTYP       IFEQ      'S'
     C                   EXSR      VAL_SWPSCH
     C                   ENDIF
 
      * Validate Sweep Capitalized Interest
 
     C                   EXSR      VAL_SCPI
 
      * If Sweep Type = ZERO BALANCE
      *  Validate Sweep Cleared Balance on Association Date
 
     C     I_SSTYP       IFEQ      'Z'
     C                   EXSR      VAL_SCBD
     C                   ENDIF
 
      * If Sweep Type = ZERO BALANCE
      *  Validate Zero Balance - Net or Gross
 
     C     I_SSTYP       IFEQ      'Z'
     C                   EXSR      VAL_ZBNG
     C                   ENDIF
 
      * If Sweep Type = ZERO BALANCE
      *  Validate Target Balance
 
     C     I_SSTYP       IFEQ      'Z'
     C                   EXSR      VAL_TGBL
     C                   ENDIF
 
      * If Sweep Type = ZERO BALANCE
      *  Validate Reverse Sweep
 
     C     I_SSTYP       IFEQ      'Z'
     C                   EXSR      VAL_RVSW
     C                   ENDIF
 
      * Validate Shadow A/c
 
     C     I_SSTYP       IFEQ      'Z'
     C                   EXSR      VAL_SACCID
     C                   ENDIF
 
      * Validate Internal Interest Income Account
 
     C     I_SSTYP       IFEQ      'Z'
     C                   EXSR      VAL_IIACID
     C                   ENDIF
 
      * Validate Internal Interest Expense Account
 
     C     I_SSTYP       IFEQ      'Z'
     C                   EXSR      VAL_IEACID
     C                   ENDIF
 
      * If Sweep Type = SWEEP
      *  Validate Sweeping Balances
 
     C     I_SSTYP       IFEQ      'S'
     C                   EXSR      VAL_SWPBALS
     C                   ENDIF
 
      *  Validate Maximum Debit Value in a Day
 
     C                   EXSR      VAL_MDVD
 
      *  Validate Maximum Debit Count in a Day
 
     C                   EXSR      VAL_MDCD
 
      *  Validate Floor Limit for Top
 
     C                   EXSR      VAL_FLFT
 
      *  Validate Floor Limit for Sweep
 
     C                   EXSR      VAL_FLFS
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Validate (Child) Narrative
      ********************************************************************
     C     VAL_CNAR      BEGSR
 
      * 'Narrative must be defined'
 
     C     I_SCNAR       IFEQ      *BLANK
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMCNAR   '   FldNameArr(Ix)
     C                   MOVEL     'RE75280'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Sweep Type
      ********************************************************************
     C     VAL_STYP      BEGSR
 
      * 'Sweep type must be S or Z'
      *  (SWEEPING or ZERO BALANCING)
 
     C     I_SSTYP       IFNE      'S'
     C     I_SSTYP       ANDNE     'Z'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMSTYP   '   FldNameArr(Ix)
     C                   MOVEL     'RE75281'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Sweeping Schedule
      ********************************************************************
     C     VAL_SWPSCH    BEGSR
 
     C                   CALLB     'REZSWPSCH'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
      * Link ID
      * Child Currency
      * Child A/c Category
      * Deferred Posting                                                        216106
     C                   PARM                    I_LINK            9 0
     C                   PARM                    I_CCCY            3
     C                   PARM                    I_CCAT            1
     C                   PARM                    I_DEFP            1            216106
      * Sweeping Frequency - COB
      * Sweeping Day - COB
      * Next Sweep Date - COB
     C                   PARM                    I_SSFRQ           1
     C                   PARM                    I_SSDAY           2
     C                   PARM                    I_SNSDT           6
 
      * External                                                                214552
      * Master Account                                                          214552
     C                   PARM                    I_SEXTL           1            214552
     C                   PARM                    I_SMAST           1            214552
      * Sweeping Holiday Convention - COB
     C                   PARM                    I_SSHOC           1
      * Sweeping Day - COB     (in numeric form)
      * Next Sweep Date - COB  (in numeric form)
     C                   PARM                    I_SDAY            2 0
     C                   PARM                    I_NSDT            5 0
 
      * SDBANKPD
      * SDGELRPD
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
 
      * OUTPUTS
      * Sweeping Day - COB
      * Next Sweep Date - COB
     C                   PARM                    O_SDAY            2 0
     C                   PARM                    O_NSDT            5 0
 
      * Following Sweep Date
     C                   PARM                    O_FSDT            5 0
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN SWEEPING SCHEDULE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Sweep Capitalized Interest
      ********************************************************************
     C     VAL_SCPI      BEGSR
 
      * 'Sweep Capitalized Interest must be Y or N'
 
     C     I_SSCPI       IFNE      'Y'
     C     I_SSCPI       ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMSCPI   '   FldNameArr(Ix)
     C                   MOVEL     'RE75282'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Sweep Cleared Balance on Association Date
      ********************************************************************
     C     VAL_SCBD      BEGSR
 
      * 'Sweep Cleared Balance on Association Date must be Y or N'
 
     C     I_SSCBD       IFNE      'Y'
     C     I_SSCBD       ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMSCBD   '   FldNameArr(Ix)
     C                   MOVEL     'RE75283'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate Zero Balance - Net or Gross
      ********************************************************************
     C     VAL_ZBNG      BEGSR
 
      * 'Zero Balance - Net or Gross must be N or G'
 
     C     I_SZBNG       IFNE      'N'
     C     I_SZBNG       ANDNE     'G'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMZBNG   '   FldNameArr(Ix)
     C                   MOVEL     'RE75284'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate Target Balance
      ********************************************************************
     C     VAL_TGBL      BEGSR
 
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      I_STGBL       ZFLD17
     C     15            SUB       A6NBDP        ZSDIG
     C                   Z-ADD     A6NBDP        ZSDEC
     C                   EXSR      ZASIGN
 
      * 'Invalid Target Balance'
     C     ZAsignOK      IFEQ      'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMTGBL   '   FldNameArr(Ix)
     C                   MOVEL     'RE75285'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
     C                   MOVE      ZOUT15        O_TGBL
     C     ZFSIGN        IFNE      '-'
     C                   Z-SUB     O_TGBL        O_TGBL
     C                   END
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate Reverse Sweep
      ********************************************************************
     C     VAL_RVSW      BEGSR
 
      * 'Reverse Sweep must be Y or N'
 
     C     I_SRVSW       IFNE      'Y'
     C     I_SRVSW       ANDNE     'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMRVSW   '   FldNameArr(Ix)
     C                   MOVEL     'RE75286'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Validate Shadow A/c
      ********************************************************************
     C     VAL_SACCID    BEGSR
 
      * 'Invalid Shadow Account.'
 
     C                   MOVEL     I_SACCID      ACCID
     C     ACCID         IFNE      BlankAC
     C                   EXSR      ACS_ACCNT
     C     *IN60         IFEQ      '1'
     C     CCY           ORNE      I_CCCY
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'SACCID   '   FldNameArr(Ix)
     C                   MOVEL     'RE75288'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
 
      * 'Shadow account can't exist in any hierarchy'
 
     C*****ACCNTK********CHAIN     REZSHLJ2                           60        212463
     C***60ACCNTK********CHAIN     REGAHLJ2                           60        212463
     C     ACCNTK        CHAIN     REZSMXL1                           60        212463
     C   60ACCNTK        CHAIN     REGAMXL1                           60        212463
     C     *IN60         IFEQ      '0'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'SACCID   '   FldNameArr(Ix)
     C                   MOVEL     'RE75303'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      * Validate Internal Interest Income Account
      ********************************************************************
     C     VAL_IIACID    BEGSR
 
      * 'Invalid Interest Income Account'
 
     C                   MOVEL     I_IIACID      ACCID
     C     ACCID         IFNE      BlankAC
     C                   EXSR      ACS_ACCNT
     C     *IN60         IFEQ      '1'
     C     CCY           ORNE      I_CCCY
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'IIACID   '   FldNameArr(Ix)
     C                   MOVEL     'RE76019'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      * Validate Internal Interest Expense Account
      ********************************************************************
     C     VAL_IEACID    BEGSR
 
      * 'Invalid Interest Credit Account'
 
     C                   MOVEL     I_IEACID      ACCID
     C     ACCID         IFNE      BlankAC
     C                   EXSR      ACS_ACCNT
     C     *IN60         IFEQ      '1'
     C     CCY           ORNE      I_CCCY
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'IEACID   '   FldNameArr(Ix)
     C                   MOVEL     'RE76018'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate Sweeping Balances
      ********************************************************************
     C     VAL_SWPBALS   BEGSR
 
      * 'Invalid Minimum Balance'
 
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      I_SMINB       ZFLD17
     C     15            SUB       A6NBDP        ZSDIG
     C                   Z-ADD     A6NBDP        ZSDEC
 
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMMINB   '   FldNameArr(Ix)
     C                   MOVEL     'RE75289'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
     C                   MOVE      ZOUT15        O_MINB
     C     ZFSIGN        IFNE      '-'
     C                   Z-SUB     O_MINB        O_MINB
     C                   END
     C                   END
 
      * 'Invalid Minimum Level'
 
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      I_SMINL       ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMMINL   '   FldNameArr(Ix)
     C                   MOVEL     'RE75290'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
     C                   MOVE      ZOUT15        O_MINL
     C     ZFSIGN        IFNE      '-'
     C                   Z-SUB     O_MINL        O_MINL
     C                   END
     C                   END
 
      * 'Invalid Maximum Balance'
 
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      I_SMAXB       ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMMAXB   '   FldNameArr(Ix)
     C                   MOVEL     'RE75291'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
     C                   MOVE      ZOUT15        O_MAXB
     C     ZFSIGN        IFNE      '-'
     C                   Z-SUB     O_MAXB        O_MAXB
     C                   END
     C                   END
 
      * 'Invalid Maximum Level'
 
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      I_SMAXL       ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMMAXL   '   FldNameArr(Ix)
     C                   MOVEL     'RE75292'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   ELSE
     C                   MOVE      ZOUT15        O_MAXL
     C     ZFSIGN        IFNE      '-'
     C                   Z-SUB     O_MAXL        O_MAXL
     C                   END
     C                   END
 
      * 'Minimum level must be above minimum balance'
      * (NOTE: credit balance is -ve, debit balance is +ve)
 
     C     O_MINL        IFGE      O_MINB
     C     O_MINL        ANDNE     0
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMMINL   '   FldNameArr(Ix)
     C                   MOVEL     'RE75293'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   END
 
      * 'Maximum level must be below maximum balance'
 
     C     O_MAXL        IFLE      O_MAXB
     C     O_MAXL        ANDNE     0
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMMAXL   '   FldNameArr(Ix)
     C                   MOVEL     'RE75294'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   END
 
      * 'Minimum balance must be below or equal to maximum balance'
 
     C     O_MINB        IFLT      O_MAXB
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMMINB   '   FldNameArr(Ix)
     C                   MOVEL     'RE75295'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   END
 
      * 'Minimum level must be below or equal to maximum level'
 
     C     O_MINL        IFLT      O_MAXL
     C     O_MINL        ANDNE     *ZERO
     C     O_MAXL        ANDNE     *ZERO
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMMINB   '   FldNameArr(Ix)
     C                   MOVEL     'RE75296'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   END
 
      * 'Minimum level must be zero if both minimum and maximum balances are 0'
 
     C     O_MINL        IFNE      0
     C     O_MINB        ANDEQ     *ZERO
     C     O_MAXB        ANDEQ     *ZERO
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMMINL   '   FldNameArr(Ix)
     C                   MOVEL     'RE75297'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   END
 
      * 'Maximum level must be zero if both minimum and maximum balances are 0'
 
     C     O_MAXL        IFNE      0
     C     O_MINB        ANDEQ     *ZERO
     C     O_MAXB        ANDEQ     *ZERO
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMMAXL   '   FldNameArr(Ix)
     C                   MOVEL     'RE75298'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate Maximum Debit Value in a Day
      ********************************************************************
     C     VAL_MDVD      BEGSR
 
      * 'Invalid Maximum Debit Value in a Day'
 
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      I_SMDVD       ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMMDVD   '   FldNameArr(Ix)
     C                   MOVEL     'RE75299'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate Maximum Debit Count in a Day
      ********************************************************************
     C     VAL_MDCD      BEGSR
 
      * 'Invalid Maximum Debit Count in a Day'
 
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      I_SMDCD       ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMMDCD   '   FldNameArr(Ix)
     C                   MOVEL     'RE75300'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate Floor Limit for Top
      ********************************************************************
     C     VAL_FLFT      BEGSR
 
      * 'Invalid Floor Limit for Top'
 
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      I_SFLFT       ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMFLFT   '   FldNameArr(Ix)
     C                   MOVEL     'RE75301'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      *  Validate Floor Limit for Sweep
      ********************************************************************
     C     VAL_FLFS      BEGSR
 
      * 'Invalid Floor Limit for Sweep'
 
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      I_SFLFS       ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   EXSR      CHK_4RETURN
     C                   ADD       1             Ix
     C                   MOVEL     'ZMFLFS   '   FldNameArr(Ix)
     C                   MOVEL     'RE75302'     MsgIDArr(Ix)
     C**********         MOVEL     I_LINK        MsgDtaArr(Ix)                              MD000091
     C                   MOVEL     I_LINK        MsgDtaTmp                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(MsgDtaTmp)                 MD000091
     C                   END
 
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
      * Check for Return
      ********************************************************************
     C     CHK_4RETURN   BEGSR
     C     Ix            IFEQ      ArrayMax
     C                   RETURN
     C                   ENDIF
     C                   ENDSR
      *******************************************************************
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
      * Link ID
      * Child Currency
      * Child A/c Category
      * Deferred Posting                                                        216106
     C                   PARM                    I_LINK            9 0
     C                   PARM                    I_CCCY            3
     C                   PARM                    I_CCAT            1
     C                   PARM                    I_DEFP            1            216106
      * Child Narrative
     C                   PARM                    I_SCNAR          30
      * Sweep Type
     C                   PARM                    I_SSTYP           1
      * Sweeping Frequency - COB
      * Sweeping Day - COB
      * Next Sweep Date - COB
     C                   PARM                    I_SSFRQ           1
     C                   PARM                    I_SSDAY           2
     C                   PARM                    I_SNSDT           6
 
      * External                                                                214552
      * Master Account                                                          214552
     C                   PARM                    I_SEXTL           1            214552
     C                   PARM                    I_SMAST           1            214552
      * Sweeping Holiday Convention - COB
     C                   PARM                    I_SSHOC           1
      * Sweep Capitalized Interest
     C                   PARM                    I_SSCPI           1
      * Sweep Cleared Balance on Association Date
      * Zero Balance - Net or Gross
     C                   PARM                    I_SSCBD           1
     C                   PARM                    I_SZBNG           1
      * Target Balance
     C                   PARM                    I_STGBL          22
      * Reverse Sweep
     C                   PARM                    I_SRVSW           1
 
      * Shadow a/c
     C**********         PARM                    I_SACCID         18                          CGL029
     C                   PARM                    I_SACCID                                     CGL029
      * Internal Interest Income Account
     C**********         PARM                    I_IIACID         18                          CGL029
     C                   PARM                    I_IIACID                                     CGL029
      * Internal Interest Expense Account
     C**********         PARM                    I_IEACID         18                          CGL029
     C                   PARM                    I_IEACID                                     CGL029
 
      * Minimum Balance
      * Minimum Level
      * Maximum Balance
      * Maximum Level
     C                   PARM                    I_SMINB          22
     C                   PARM                    I_SMINL          22
     C                   PARM                    I_SMAXB          22
     C                   PARM                    I_SMAXL          22
 
      * Maximum Debit Value in a Day
      * Maximum Debit Count in a Day
     C                   PARM                    I_SMDVD          22
     C                   PARM                    I_SMDCD           5
 
      * Floor Limit for Top
      * Floor Limit for Sweep
     C                   PARM                    I_SFLFT          22
     C                   PARM                    I_SFLFS          22
 
      * BANK details
      * GENERAL LEDGER details
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
 
      * OUTPUTS
      * Following Sweep Date
     C                   PARM                    O_FSDT            5 0
      * Target Balance
      * Minimum Balance
      * Minimum Level
      * Maximum Balance
      * Maximum Level
     C                   PARM                    O_TGBL           15 0
     C                   PARM                    O_MINB           15 0
     C                   PARM                    O_MINL           15 0
     C                   PARM                    O_MAXB           15 0
     C                   PARM                    O_MAXL           15 0
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
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
