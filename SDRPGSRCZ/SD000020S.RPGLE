     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Non-a/c Holder Selection')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000020S - Midas SD Non-a/c Holder Selection                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CGL132             Date 01May13               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG24155           Date 01Jun09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 233207  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master (Recompile)                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24155 - Database Error Occurs when selecting              *
      *          2 Authority Holders                                  *
      *  233207 - Non-account Holders Selection Processing            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDNAHOL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDNAHOD0:SDNAHOD1)
      ** Midas SD Non-a/c Holders by Non-a/c Holder Reference
 
     FSDNAHOL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDNAHOD0:SDNAHOD2)
      ** Midas SD Non-a/c Holders by Front Office ID
 
     FSD000020S#CF   E             WORKSTN SFILE(SD000020S0:#0SFRN)
     F                                     SFILE(SD000020S1:#1SFRN)
      ** Midas SD Non-a/c Holder Selection Display File
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition.
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all of the defined fields
      ** in the PSDS. They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Uppercase & Lowercase Constants
     D UP              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D LO              C                   'abcdefghijklmnopqrstuvwxyz'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Indicator Array Overlay Data Structure
     D INPTR           S               *   INZ(%ADDR(*IN))
     D                 DS                  BASED(INPTR)
 
      ** Function Key Indicators
     D  F03                   03     03
     D  F11                   11     11
 
      ** Subfile Management Indicators
     D  SFLCLR                91     91
     D  SFLDSP                92     92
     D  SFLEND                93     93
     D  ROLLUP                94     94
     D  SFLNXTCHG             95     95
     D  SFLMSGEND             96     96
 
      ** Bank Details Data Structure
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program Parameters
     D PRetCde         S              7A
     D PNAHo           S             10A
 
      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
 
      ** Standard Utility Parameters
     D PMsgFile        S             10A   INZ('SDUSRMSG')
     D PMsgID          S             10A
 
      ** Working Variables
     D WNAHoCnt        S              4P 0
     D WNRecCnt        S              4P 0
     D W0SFRN          S              4P 0
     D W1SFRN          S              4P 0
 
     D WNErrFlg        S              1A
     D WNDspFlg        S              1A
     D WNBldFlg        S              1A
 
     D WRead           S              1A
     D WEoF            S              1A
     D WFound          S              1A
     D WSrcStr         S             20A
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   DOW       F03 = *OFF
     C                   EXSR      SRNAHoMain
     C                   ENDDO
 
     C                   EXSR      SREndPgm
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNAHoMain - Manages the Non-a/c Holders subfile.            *
      *                                                               *
      *****************************************************************
     C     SRNAHoMain    BEGSR
 
      *************************************************
      ** Non-a/c Holders by Non-a/c Holder Reference **
      *************************************************
 
     C                   EXSR      SRNAHoInit
 
     C                   EXSR      SRNAHoClr
 
     C                   DOW       F03 = *OFF
 
     C                   EXSR      SRNAHoBld
 
     C                   EXSR      SRNAHoDsp
 
     C                   IF        F03 = *OFF AND
     C                             ROLLUP = *OFF AND
     C                             WRead = 'Y'
 
     C                   SELECT
 
     C                   WHEN      F11 = *ON
     C                   LEAVE
     C                   OTHER
 
     C                   EXSR      SRNAHoVal
 
     C                   IF        WNDspFlg = 'N' AND
     C                             WNBldFlg = 'N'
     C                   EXSR      SREndPgm
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDDO
 
      ****************************************
      ** Non-a/c Holders by Front Office ID **
      ****************************************
 
     C                   EXSR      SRNAHoInit2
 
     C                   EXSR      SRNAHoClr2
 
     C                   DOW       F03 = *OFF
 
     C                   EXSR      SRNAHoBld2
 
     C                   EXSR      SRNAHoDsp2
 
     C                   IF        F03 = *OFF AND
     C                             ROLLUP = *OFF AND
     C                             WRead = 'Y'
 
     C                   SELECT
 
     C                   WHEN      F11 = *ON
     C                   LEAVE
     C                   OTHER
 
     C                   EXSR      SRNAHoVal2
 
     C                   IF        WNDspFlg = 'N' AND
     C                             WNBldFlg = 'N'
     C                   EXSR      SREndPgm
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        F03 = *ON
     C                   EVAL      PRetCde = '*NOSEL '
     C                   EVAL      PNAHo = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNAHoInit - Handles the initial Non-a/c Holders             *
      *               subfile processing.                             *
      *                                                               *
      *****************************************************************
     C     SRNAHoInit    BEGSR
 
      ** Initialise relevant variables.
 
     C                   EVAL      W0SFRN = *ZERO
     C                   EVAL      #0SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
 
      ** Initialise processing flags.
 
     C     *LOVAL        SETLL     SDNAHOL1
     C                   READ      SDNAHOL1
 
     C                   EVAL      WRead = 'N'
     C                   IF        NOT %EOF(SDNAHOL1)
     C                   EVAL      WRead = 'Y'
     C                   ENDIF
 
     C                   EVAL      WNErrFlg = 'N'
     C                   EVAL      WNDspFlg = 'N'
     C                   EVAL      WNBldFlg = 'N'
 
      ** Set the file pointer.
 
     C     *LOVAL        SETLL     SDNAHOL1
 
      ** Reset the subfile error indicator.
 
     C                   EVAL      *IN21 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNAHoInit2 - Handles the initial Non-a/c Holders            *
      *                subfile processing.                            *
      *                                                               *
      *****************************************************************
     C     SRNAHoInit2   BEGSR
 
      ** Initialise relevant variables.
 
     C                   EVAL      W1SFRN = *ZERO
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
 
      ** Initialise processing flags.
 
     C     *LOVAL        SETLL     SDNAHOL2
     C                   READ      SDNAHOL2
 
     C                   EVAL      WRead = 'N'
     C                   IF        NOT %EOF(SDNAHOL2)
     C                   EVAL      WRead = 'Y'
     C                   ENDIF
 
     C                   EVAL      WNErrFlg = 'N'
     C                   EVAL      WNDspFlg = 'N'
     C                   EVAL      WNBldFlg = 'N'
 
      ** Set the file pointer.
 
     C     *LOVAL        SETLL     SDNAHOL2
 
      ** Reset the subfile error indicator.
 
     C                   EVAL      *IN21 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNAHoClr - Clears the Non-a/c Holders subfile.              *
      *                                                               *
      *****************************************************************
     C     SRNAHoClr     BEGSR
 
     C                   EVAL      SFLCLR = *ON
     C                   WRITE     SD000020C0
     C                   EVAL      SFLCLR = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNAHoClr2 - Clears the Non-a/c Holders subfile.             *
      *                                                               *
      *****************************************************************
     C     SRNAHoClr2    BEGSR
 
     C                   EVAL      SFLCLR = *ON
     C                   WRITE     SD000020C1
     C                   EVAL      SFLCLR = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNAHoBld - Builds the Non-a/c Holders subfile.              *
      *                                                               *
      *****************************************************************
     C     SRNAHoBld     BEGSR
 
      ** Build the subfile only if necessary.
 
     C                   IF        WNDspFlg = 'Y' AND
     C                             ROLLUP = *OFF
     C                   LEAVESR
     C                   ENDIF
 
      ** Build the subfile starting from the given key.
 
     C                   IF        WNBldFlg = 'Y'
 
     C                   EXSR      SRNAHoClr
     C                   EVAL      W0SFRN = *ZERO
     C                   EVAL      #0SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      WNBldFlg = 'N'
 
     C     *LOVAL        SETLL     SDNAHOL1
     C                   ENDIF
 
     C                   EVAL      WNAHoCnt = *ZERO
 
      ** Select all Non-a/c Holders.
 
     C                   EXSR      SRNAHoRead
 
     C                   DOW       WEoF <> 'Y'
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      #0ACTN = *BLANK
     C                   EVAL      #0NAHO = NHNAHO
     C                   EVAL      #0NARN = NHNARN
     C                   EVAL      #0NATW = NHNATW
     C                   EVAL      W0SFRN = W0SFRN + 1
     C                   EVAL      #0SFRN = W0SFRN
     C                   EVAL      WNAHoCnt = WNAHoCnt + 1
     C                   WRITE     SD000020S0
 
      ** Leave the Non-a/c Holders selection if one subfile
      ** page has been filled.
 
     C                   IF        WNAHoCnt = 14
 
      ** Check first if there are more records available.
 
     C                   READ      SDNAHOL1
 
     C                   IF        %EOF(SDNAHOL1)
     C                   LEAVE
     C                   ELSE
     C                   READP     SDNAHOL1
     C                   ENDIF
 
     C                   LEAVESR
     C                   ENDIF
 
     C                   EXSR      SRNAHoRead
     C                   ENDDO
 
      ** No details to display.
 
     C                   IF        W0SFRN = *ZERO
     C**********         EVAL      PMsgID = 'SDM0137'                                       BUG24155
     C                   EVAL      PMsgID = 'SDA0004'                                       BUG24155
     C                   EXSR      SRSndErr
     C                   EVAL      SFLDSP = *OFF
     C                   ENDIF
 
     C                   EVAL      ROLLUP = *OFF
     C                   EVAL      SFLEND = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNAHoBld2 - Builds the Non-a/c Holders subfile.             *
      *                                                               *
      *****************************************************************
     C     SRNAHoBld2    BEGSR
 
      ** Build the subfile only if necessary.
 
     C                   IF        WNDspFlg = 'Y' AND
     C                             ROLLUP = *OFF
     C                   LEAVESR
     C                   ENDIF
 
      ** Build the subfile starting from the given key.
 
     C                   IF        WNBldFlg = 'Y'
 
     C                   EXSR      SRNAHoClr2
     C                   EVAL      W1SFRN = *ZERO
     C                   EVAL      #1SFRN = *ZERO
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLEND = *OFF
     C                   EVAL      WNBldFlg = 'N'
 
     C     *LOVAL        SETLL     SDNAHOL2
     C                   ENDIF
 
     C                   EVAL      WNAHoCnt = *ZERO
 
      ** Select all Non-a/c Holders.
 
     C                   EXSR      SRNAHoRead2
 
     C                   DOW       WEoF <> 'Y'
 
     C                   EVAL      *IN21 = *OFF
     C                   EVAL      #1ACTN = *BLANK
     C                   EVAL      #1FRNT = NHFRNT
     C                   EVAL      #1NAHO = NHNAHO
     C                   EVAL      #1NATW = NHNATW
     C                   EVAL      W1SFRN = W1SFRN + 1
     C                   EVAL      #1SFRN = W1SFRN
     C                   EVAL      WNAHoCnt = WNAHoCnt + 1
     C                   WRITE     SD000020S1
 
      ** Leave the Non-a/c Holders selection if one subfile
      ** page has been filled.
 
     C                   IF        WNAHoCnt = 14
 
      ** Check first if there are more records available.
 
     C                   READ      SDNAHOL2
 
     C                   IF        %EOF(SDNAHOL2)
     C                   LEAVE
     C                   ELSE
     C                   READP     SDNAHOL2
     C                   ENDIF
 
     C                   LEAVESR
     C                   ENDIF
 
     C                   EXSR      SRNAHoRead2
     C                   ENDDO
 
      ** No details to display.
 
     C                   IF        W1SFRN = *ZERO
     C**********         EVAL      PMsgID = 'SDM0137'                                       BUG24155
     C                   EVAL      PMsgID = 'SDA0004'                                       BUG24155
     C                   EXSR      SRSndErr
     C                   EVAL      SFLDSP = *OFF
     C                   ENDIF
 
     C                   EVAL      ROLLUP = *OFF
     C                   EVAL      SFLEND = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNAHoDsp - Displays the Non-a/c Holders subfile.            *
      *                                                               *
      *****************************************************************
     C     SRNAHoDsp     BEGSR
 
      ** Display the full Non-a/c Holders selection screen.
 
     C                   WRITE     SD000020F0
     C                   WRITE     SD000020C2
     C                   WRITE     SD000020F1
     C                   EXFMT     SD000020C0
 
      ** Clear all messages from the Program Message Queue.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNAHoDsp2 - Displays the Non-a/c Holders subfile.           *
      *                                                               *
      *****************************************************************
     C     SRNAHoDsp2    BEGSR
 
      ** Display the full Non-a/c Holders selection screen.
 
     C                   WRITE     SD000020F0
     C                   WRITE     SD000020C2
     C                   WRITE     SD000020F2
     C                   EXFMT     SD000020C1
 
      ** Clear all messages from the Program Message Queue.
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNAHoVal - Validates the Non-a/c Holders subfile.           *
      *                                                               *
      *****************************************************************
     C     SRNAHoVal     BEGSR
 
      ** Initialise processing flags.
 
     C                   EVAL      WNErrFlg = 'N'
     C                   EVAL      WNDspFlg = 'N'
     C                   EVAL      WNBldFlg = 'N'
 
      ** Reset the subfile error indicator.
 
     C                   EVAL      *IN21 = *OFF
 
     C                   EVAL      WNRecCnt = *ZERO
 
     C                   READC     SD000020S0
 
     C                   DOW       NOT %EOF
 
     C                   EVAL      *IN21 = *OFF
 
      ** Validate the Non-a/c Holder Action Code.
 
     C                   EXSR      SRVNActCde
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    SD000020S0
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     SD000020S0
     C                   ENDDO
 
     C                   IF        WNErrFlg = 'Y'
     C                   EVAL      WNDspFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Read the subfile selection.
 
     C                   READC     SD000020S0
 
     C                   DOW       NOT %EOF
 
     C                   IF        #0ACTN = '1'
 
      ** At this point, a valid Non-a/c Holder has been selected.
 
     C                   EVAL      PRetCde = *BLANKS
     C                   EVAL      PNAHo = #0NAHO
     C                   LEAVESR
     C                   ENDIF
 
     C                   READC     SD000020S0
     C                   ENDDO
 
     C                   EVAL      WNBldFlg = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNAHoVal2 - Validates the Non-a/c Holders subfile.          *
      *                                                               *
      *****************************************************************
     C     SRNAHoVal2    BEGSR
 
      ** Initialise processing flags.
 
     C                   EVAL      WNErrFlg = 'N'
     C                   EVAL      WNDspFlg = 'N'
     C                   EVAL      WNBldFlg = 'N'
 
      ** Reset the subfile error indicator.
 
     C                   EVAL      *IN21 = *OFF
 
     C                   EVAL      WNRecCnt = *ZERO
 
     C                   READC     SD000020S1
 
     C                   DOW       NOT %EOF
 
     C                   EVAL      *IN21 = *OFF
 
      ** Validate the Non-a/c Holder Action Code.
 
     C                   EXSR      SRVNActCde2
 
     C                   EVAL      SFLNXTCHG = *ON
     C                   UPDATE    SD000020S1
     C                   EVAL      SFLNXTCHG = *OFF
 
     C                   READC     SD000020S1
     C                   ENDDO
 
     C                   IF        WNErrFlg = 'Y'
     C                   EVAL      WNDspFlg = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
      ** Read the subfile selection.
 
     C                   READC     SD000020S1
 
     C                   DOW       NOT %EOF
 
     C                   IF        #1ACTN = '1'
 
      ** At this point, a valid Non-a/c Holder has been selected.
 
     C                   EVAL      PRetCde = *BLANKS
     C                   EVAL      PNAHo = #1NAHO
     C                   LEAVESR
     C                   ENDIF
 
     C                   READC     SD000020S1
     C                   ENDDO
 
     C                   EVAL      WNBldFlg = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNAHoRead - Reads Non-a/c Holders.                          *
      *                                                               *
      *****************************************************************
     C     SRNAHoRead    BEGSR
 
     C                   EVAL      WEoF = 'N'
     C                   EVAL      WFound = 'N'
 
     C                   READ      SDNAHOL1
 
     C                   DOW       NOT %EOF(SDNAHOL1)
 
     C                   IF        NHCHTP <> 'D'
 
     C                   EVAL      WFound = 'Y'
 
      ** Search for the input keys on every record read if necessary.
 
      ** Non-a/c Holder Reference
 
     C                   IF        #0KNAH <> *BLANKS AND
     C                             WFound = 'Y'
     C                   EVAL      WSrcStr = %XLATE(LO:UP:NHNAHO)
     C                   IF        %SCAN(%TRIM(#0KNAH):WSrcStr) = *ZERO
     C                   EVAL      WFound = 'N'
     C                   ENDIF
     C                   ENDIF
 
      ** Non-a/c Holder Report Name
 
     C                   IF        #0KNRN <> *BLANKS AND
     C                             WFound = 'Y'
     C                   EVAL      WSrcStr = %XLATE(LO:UP:NHNARN)
     C                   IF        %SCAN(%TRIM(#0KNRN):WSrcStr) = *ZERO
     C                   EVAL      WFound = 'N'
     C                   ENDIF
     C                   ENDIF
 
      ** Non-a/c Holder Report Town
 
     C                   IF        #0KNTW <> *BLANKS AND
     C                             WFound = 'Y'
     C                   EVAL      WSrcStr = %XLATE(LO:UP:NHNATW)
     C                   IF        %SCAN(%TRIM(#0KNTW):WSrcStr) = *ZERO
     C                   EVAL      WFound = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WFound = 'Y'
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      SDNAHOL1
     C                   ENDDO
 
     C                   IF        %EOF(SDNAHOL1)
     C                   EVAL      WEoF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNAHoRead2 - Reads Non-a/c Holders.                         *
      *                                                               *
      *****************************************************************
     C     SRNAHoRead2   BEGSR
 
     C                   EVAL      WEoF = 'N'
     C                   EVAL      WFound = 'N'
 
     C                   READ      SDNAHOL2
 
     C                   DOW       NOT %EOF(SDNAHOL2)
 
     C                   IF        NHCHTP <> 'D'
 
     C                   EVAL      WFound = 'Y'
 
      ** Search for the input keys on every record read if necessary.
 
      ** Front Office ID
 
     C                   IF        #1KFRN <> *BLANKS AND
     C                             WFound = 'Y'
     C                   EVAL      WSrcStr = %XLATE(LO:UP:NHFRNT)
     C                   IF        %SCAN(%TRIM(#1KFRN):WSrcStr) = *ZERO
     C                   EVAL      WFound = 'N'
     C                   ENDIF
     C                   ENDIF
 
      ** Non-a/c Holder Reference
 
     C                   IF        #1KNAH <> *BLANKS AND
     C                             WFound = 'Y'
     C                   EVAL      WSrcStr = %XLATE(LO:UP:NHNAHO)
     C                   IF        %SCAN(%TRIM(#1KNAH):WSrcStr) = *ZERO
     C                   EVAL      WFound = 'N'
     C                   ENDIF
     C                   ENDIF
 
      ** Non-a/c Holder Report Town
 
     C                   IF        #1KNTW <> *BLANKS AND
     C                             WFound = 'Y'
     C                   EVAL      WSrcStr = %XLATE(LO:UP:NHNATW)
     C                   IF        %SCAN(%TRIM(#1KNTW):WSrcStr) = *ZERO
     C                   EVAL      WFound = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WFound = 'Y'
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      SDNAHOL2
     C                   ENDDO
 
     C                   IF        %EOF(SDNAHOL2)
     C                   EVAL      WEoF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVNActCde - Validates the Non-a/c Holders Action Code.      *
      *                                                               *
      *****************************************************************
     C     SRVNActCde    BEGSR
 
     C                   IF        #0ACTN <> *BLANK
 
      ** Action Code must be '1' (Select).
 
     C                   IF        #0ACTN <> '1'
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WNErrFlg = 'Y'
     C**********         EVAL      PMsgID = 'SDM0138'                                       BUG24155
     C                   EVAL      PMsgID = 'USR9358'                                       BUG24155
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Only one option can be selected.
 
     C                   EVAL      WNRecCnt = WNRecCnt + 1
 
     C                   IF        WNRecCnt > 1
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WNErrFlg = 'Y'
     C                   EVAL      PMsgID = 'SDM0139'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVNActCde2 - Validates the Non-a/c Holders Action Code.     *
      *                                                               *
      *****************************************************************
     C     SRVNActCde2   BEGSR
 
     C                   IF        #1ACTN <> *BLANK
 
      ** Action Code must be '1' (Select).
 
     C                   IF        #1ACTN <> '1'
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WNErrFlg = 'Y'
     C                   EVAL      PMsgID = 'SDM0138'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
      ** Only one option can be selected.
 
     C                   EVAL      WNRecCnt = WNRecCnt + 1
 
     C                   IF        WNRecCnt > 1
     C                   EVAL      *IN21 = *ON
     C                   EVAL      WNErrFlg = 'Y'
     C                   EVAL      PMsgID = 'SDM0139'
     C                   EXSR      SRSndErr
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndErr - Sends error messages to the Program Message       *
      *             Queue via ZA0340.                                 *
      *                                                               *
      *****************************************************************
     C     SRSndErr      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgID
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndPgm - Ends the program.                                 *
      *                                                               *
      *****************************************************************
     C     SREndPgm      BEGSR
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Return Code
     C                   PARM                    PRetCde
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** Non-a/c Holder
     C                   PARM                    PNAHo
 
      **---------------------------------------------------------------
      ** The following /COPY line sets the Program, Module, and
      ** Procedure names for Database Error Processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
      ** Access Bank Details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set the system information display fields.
 
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #2PGMQ = PSProcMod
 
     C                   EVAL      SFLDSP = *ON
     C                   EVAL      SFLMSGEND = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2005
