     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Repayments Schedule - Amend checking')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LERPSCAMD - Repayments Schedule - Amend Checking             *
      *                                                               *
      *  Function:  This module compares the fields of an amended     *
      *             repayment schedule against those currently        *
      *             on file.                                          *
      *             It checks whether all fields amended are          *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             If can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1071579          Date 29Jul16               *
      *                 CLE154             Date 02Aug12               *
      *                 MD000091           Date 10May13               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP086             Date 08Jun05               *
      *                 CAP084             Date 31Jul03               *
      *                 CAP079  *CREATE    Date 03Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1071579 - LEM - Reverse All not working fully (CLE154)     *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  MD000091 - Event Codes Substitution                          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CAP084 - MidasPlus Changes                                   *
      *  CAP079 - Lending API enhancements - Repayments schedule      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
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
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
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
      *
     D CRpScScnFmt   E DS                  EXTNAME(LERPSCPD)
      ***  (Current) Repayment schedule in Screen Format
     D                                     PREFIX(@)
      *
     D NRpScScnFmt   E DS                  EXTNAME(LERPSCPD)
      ***  New Repayment schedule in Screen Format
      *
     D RUNDAT          DS
     D  @MBIN                 13     13
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, SHORT data structure
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
      ***  Index for arrays of of error message ids etc
      *
     D OkRpScScr     E DS                  EXTNAME(LEERPSCPD)
      ***  Error indicators screen 1
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      *                                                                                     MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ***  Compare fields with "amended" values or "changed" values.
      *
     C                   EXSR      COMPFLD
      *
      ***  If any errors were found
      ***  and reset of fields in error required, do this
      *
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      RESETFLD
     C                   ENDIF
      *
      ***  Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * COMPFLD  - Compare certain fields on the current repayment    *
      *            schedule with those "amended".                     *
      *****************************************************************
     C     COMPFLD       BEGSR
      *
      *-----------------------------------------*
      * Loan number                             *
      *-----------------------------------------*
      *
     C     DDLNRF        IFNE      @DDLNRF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLNRF'
     C                   EVAL      MsgIDArr(Idx)   = 'LES0600'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDLNRF                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDLNRF))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDLNRF)                  MD000091
     C                   EVAL      DDLNRFok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Sequence                                *
      *-----------------------------------------*
      *
     C     DDSEQN        IFNE      @DDSEQN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSEQN'
     C                   EVAL      MsgIDArr(Idx)   = 'LES0601'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDSEQN                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDSEQN))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDSEQN)                  MD000091
     C                   EVAL      DDSEQNok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Customer number                         *
      *-----------------------------------------*
      *
     C     DDCUST        IFNE      @DDCUST
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'
     C                   EVAL      MsgIDArr(Idx)   = 'LES0602'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDCUST                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDCUST))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDCUST)                  MD000091
     C                   EVAL      DDCUSTok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Value date                              *
      *-----------------------------------------*
      *
     C     DDVDAT        IFNE      @DDVDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'LES0603'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDVDAT                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDVDAT))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDVDAT)                  MD000091
     C                   EVAL      DDVDATok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Currency                                *
      *-----------------------------------------*
      *
     C     DDCURR        IFNE      @DDCURR
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCURR'
     C                   EVAL      MsgIDArr(Idx)   = 'LES0604'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDCURR                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDCURR))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDCURR)                  MD000091
     C                   EVAL      DDCURRok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Amount                                  *
      *-----------------------------------------*
      *
     C     DDACTN        IFNE      'R'                                                   AR1071579
      * Call ZCMPAMTS to compare the two screen amounts                                     CAP084
                                                                                            CAP084
     C                   CALLB     'ZCMPAMTS'                                               CAP084
     C                   PARM      DDSAMT        ZCMPAMT1         25                        CAP084
     C                   PARM      @DDSAMT       ZCMPAMT2         25                        CAP084
     C                   PARM      'N'           ZCMPAMTDif        1                        CAP084
                                                                                            CAP084
     C*****DDSAMT        IFNE      @DDSAMT                                                  CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                                      CAP084
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSAMT'
     C                   EVAL      MsgIDArr(Idx)   = 'LES0605'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDSAMT                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDSAMT))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDSAMT)                  MD000091
     C                   EVAL      DDSAMTok        = 'N'
     C                   END
     C                   ENDIF                                                           AR1071579
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETFLD - Reset fields in Error                              *
      *****************************************************************
     C     RESETFLD      BEGSR
      *
      ***  Reset fields in error to 'current' values
      *    =========================================
      *
      *-----------------------------------------*
      * Loan number                             *
      *-----------------------------------------*
      *
     C     DDLNRFok      IFEQ      'N'
     C                   MOVEL     @DDLNRF       DDLNRF
     C                   END
      *
      *-----------------------------------------*
      * Sequence                                *
      *-----------------------------------------*
      *
     C     DDSEQNok      IFEQ      'N'
     C                   MOVEL     @DDSEQN       DDSEQN
     C                   END
      *
      *-----------------------------------------*
      * Customer number                         *
      *-----------------------------------------*
      *
     C     DDCUSTok      IFEQ      'N'
     C                   MOVEL     @DDCUST       DDCUST
     C                   END
      *
      *-----------------------------------------*
      * Value date                              *
      *-----------------------------------------*
      *
     C     DDVDATok      IFEQ      'N'
     C                   MOVEL     @DDVDAT       DDVDAT
     C                   END
      *
      *-----------------------------------------*
      * Currency                                *
      *-----------------------------------------*
      *
     C     DDCURRok      IFEQ      'N'
     C                   MOVEL     @DDCURR       DDCURR
     C                   END
      *
      *-----------------------------------------*
      * Amount                                  *
      *-----------------------------------------*
      *
     C     DDSAMTok      IFEQ      'N'
     C                   MOVEL     @DDSAMT       DDSAMT
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ***  INPUTS
      *
      ***  Return Code
     C                   PARM                    RetCodeIn
      *
      ***  New Repayment schedule in Screen Format :
     C                   PARM                    NRpScScnFmt
      *
      ***  (Current) Repayment schedule in Screen Format :
     C                   PARM                    CRpScScnFmt
      *
      ***  OUTPUTS
      *
      ***  Error Indicators
     C                   PARM                    OkRpScScr
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ***  Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LERPSCAMD'   DBPGM
      *
      ***  Get rundat to access multi-branching flag.
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
