     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual Repayment input - Amendable')          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEMAPYAMD -  Manual Repayment input - Amend Checking         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. AR1088819          Date 03Jun20               *
      *  Prev Amend No. MD049594           Date 15Feb18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD000091           Date 10May13               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 247277             Date 24May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4325            Date 26Oct04               *
      *                 BUG3114            Date 04Aug04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP077  *CREATE    Date 17Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1088819 - Issue on job names during SSL enabling of JDBC   *
      *              calls                                            *
      *            - Applied for MD050405                             *
      *  MD049594 - LEM0610 error message will only be thrown if      *
      *             DDPASD is changed to 'Y' from 'N'/'' or to 'N'/'' *
      *             from 'Y'.                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  247277 - Allow for native JDBC driver as well as toolbox.    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4325- DDESEQ (Expected sequence) written to WIP (T_MSWIP) *
      *           before sequence calculated. This is when LN is      *
      *           entred originally in this field. If this field is   *
      *           LN and job is QZDASOINIT then bypass check.         *
      *  BUG3114- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP077 - Lending API enhancements - Manual Repayments        *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
      /SPACE 5
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

      ** Manual Repayment in Screen Format
     D NwMaPyScnFmt  E DS                  EXTNAME(LEMAPYPD)

      ** Manual Repayments OK indicators
     D ErrorMaPy     E DS                  EXTNAME(LEEMAPYPD)

      * (Current) Loan in Screen Format
     D CrMapyScnFmt  E DS                  EXTNAME(LEMAPYPD)
     D                                     PREFIX(@)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ***  DS for Access Objects

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  DS Returns from Access Objects

     D Idx             S              3P 0
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

      *****************************************************************
      /SPACE 5
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *
      ***  Compare fields with amended values.
      *
     C                   EXSR      COMPFLDS
      *
      ***  If any errors were found:
      ***    Set Amendments OK Indicator to 'N'
      *
      ***  If any errors were found:
      ***  - and reset of fields in error required, do this
      *
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      RESETFLDS
     C                   ENDIF

      *** Return

     C                   MOVE      *ON           *INLR
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      * COMPFLDS  - Compare certain fields on the current deal        *
      *             with those amended.                               *
      *****************************************************************
     C     COMPFLDS      BEGSR
      *
      *-----------------------------------------*
      * Loan number                             *
      *-----------------------------------------*
      *
     C     DDLNRF        IFNE      @DDLNRF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLNRF'
     C                   EVAL      MsgIDArr(Idx)   = 'LEM0600'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDLNRF                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDLNRF))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDLNRF)                  MD000091
     C                   EVAL      DDLNRFok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Value date                              *
      *-----------------------------------------*
      *
     C     DDVALD        IFNE      @DDVALD
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVALD'
     C                   EVAL      MsgIDArr(Idx)   = 'LEM0601'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDVALD                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDVALD))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDVALD)                  MD000091
     C                   EVAL      DDVALDok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Sequence                                *
      *-----------------------------------------*
      *
     C     DDSEQN        IFNE      @DDSEQN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSEQN'
     C                   EVAL      MsgIDArr(Idx)   = 'LEM0602'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDSEQN                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDSEQN))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDSEQN)                  MD000091
     C                   EVAL      DDSEQNok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Expected Value date                      *
      *-----------------------------------------*
      *
     C     DDEVAL        IFNE      @DDEVAL
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDEVAL'
     C                   EVAL      MsgIDArr(Idx)   = 'LEM0603'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDEVAL                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDEVAL))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDEVAL)                  MD000091
     C                   EVAL      DDEVALok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Sequence                                *
      *-----------------------------------------*
      *
      * Do not do check if DDESEQ is LN and job is QZDASOINIT
      * WIP record is saved before ESEQ is calculated so is saved
      * as LN.
      *
     C     DDESEQ        IFNE      'LN '                                                     BUG4325
     C     PSJobName     ANDNE     'QZDASOINIT'                                              BUG4325
     C     PSJobName     ANDNE     'QSQSRVR'                                                  247277
     C     PSJobName     ANDNE     'QZDASSINIT'                                            AR1088819
     C     DDESEQ        IFNE      @DDESEQ
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDESEQ'
     C                   EVAL      MsgIDArr(Idx)   = 'LEM0604'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDESEQ                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDESEQ))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDESEQ)                  MD000091
     C                   EVAL      DDESEQok        = 'N'
     C                   END
     C                   END                                                                 BUG4325
      *
      *-----------------------------------------*
      * Customer number                         *
      *-----------------------------------------*
      *
     C     DDCUST        IFNE      @DDCUST
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'
     C                   EVAL      MsgIDArr(Idx)   = 'LES0605'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDCUST                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDCUST))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDCUST)                  MD000091
     C                   EVAL      DDCUSTok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * PRINCIPAL AMOUNT                        *
      *-----------------------------------------*
      *
     C                   CALLB     'ZCMPAMTS'
     C                   PARM      DDRPRI        ZCMPAMT1         25
     C                   PARM      @DDRPRI       ZCMPAMT2         25
     C                   PARM      'N'           ZCMPAMTDif        1
     C     ZCMPAMTDif    IFEQ      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRPRI'
     C                   EVAL      MsgIDArr(Idx)   = 'LEM0606'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDRPRI                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDRPRI))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDRPRI)                  MD000091
     C                   EVAL      DDRPRIok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * INTEREST AMOUNT                         *
      *-----------------------------------------*
      *
     C                   CALLB     'ZCMPAMTS'
     C                   PARM      DDRINT        ZCMPAMT1         25
     C                   PARM      @DDRINT       ZCMPAMT2         25
     C                   PARM      'N'           ZCMPAMTDif        1
     C     ZCMPAMTDif    IFEQ      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRINT'
     C                   EVAL      MsgIDArr(Idx)   = 'LEM0607'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDRINT                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDRINT))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDRINT)                  MD000091
     C                   EVAL      DDRINTok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Penalities Amount                       *
      *-----------------------------------------*
      *
     C                   CALLB     'ZCMPAMTS'
     C                   PARM      DDRPEN        ZCMPAMT1         25
     C                   PARM      @DDRPEN       ZCMPAMT2         25
     C                   PARM      'N'           ZCMPAMTDif        1
     C     ZCMPAMTDif    IFEQ      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRPEN'
     C                   EVAL      MsgIDArr(Idx)   = 'LEM0608'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDRPEN                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDRPEN))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDRPEN)                  MD000091
     C                   EVAL      DDRPENok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * TOTAL AMOUNT                            *
      *-----------------------------------------*
      *
     C                   CALLB     'ZCMPAMTS'
     C                   PARM      DDRTOT        ZCMPAMT1         25
     C                   PARM      @DDRTOT       ZCMPAMT2         25
     C                   PARM      'N'           ZCMPAMTDif        1
     C     ZCMPAMTDif    IFEQ      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRTOT'
     C                   EVAL      MsgIDArr(Idx)   = 'LEM0609'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDRTOT                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDRTOT))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDRTOT)                  MD000091
     C                   EVAL      DDRTOTok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * PAST DUE                                *
      *-----------------------------------------*
      *
     C     DDPASD        IFNE      @DDPASD
     C     DDPASD        ANDEQ     'Y'                                                      MD049594
     C     DDPASD        ORNE      @DDPASD                                                  MD049594
     C     @DDPASD       ANDEQ     'Y'                                                      MD049594
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPASD'
     C                   EVAL      MsgIDArr(Idx)   = 'LEM0610'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDPASD                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDPASD))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDPASD)                  MD000091
     C                   EVAL      DDPASDok        = 'N'
     C                   ELSE                                                               MD049594
     C                   MOVEL     @DDPASD       DDPASD                                     MD049594
     C                   END
      *
      *-----------------------------------------*
      * Write off                               *
      *-----------------------------------------*
      *
     C     DDWOFF        IFNE      @DDWOFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDWOFF'
     C                   EVAL      MsgIDArr(Idx)   = 'LEM0611'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDWOFF                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDWOFF))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDWOFF)                  MD000091
     C                   EVAL      DDWOFFok        = 'N'
     C                   END
      *
     C     ENDCOMP       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETFLDS - Reset fields in Error                             *
      *****************************************************************
     C     RESETFLDS     BEGSR

      *
      ***  Reset fields in error to 'current' values
      *    =========================================
      *
     C     DDLNRFok      IFEQ      'N'
     C                   MOVEL     @DDLNRF       DDLNRF
     C                   END

     C     DDVALDok      IFEQ      'N'
     C                   MOVEL     @DDVALD       DDVALD
     C                   END

     C     DDSEQNok      IFEQ      'N'
     C                   MOVEL     @DDSEQN       DDSEQN
     C                   END

     C     DDEVALok      IFEQ      'N'
     C                   MOVEL     @DDEVAL       DDEVAL
     C                   END

     C     DDESEQok      IFEQ      'N'
     C                   MOVEL     @DDESEQ       DDESEQ
     C                   END

     C     DDCUSTok      IFEQ      'N'
     C                   MOVEL     @DDCUST       DDCUST
     C                   END

     C     DDRPRIok      IFEQ      'N'
     C                   MOVEL     @DDRPRI       DDRPRI
     C                   END

     C     DDRINTok      IFEQ      'N'
     C                   MOVEL     @DDRINT       DDRINT
     C                   END

     C     DDRPENok      IFEQ      'N'
     C                   MOVEL     @DDRPEN       DDRPEN
     C                   END

     C     DDRTOTok      IFEQ      'N'
     C                   MOVEL     @DDRTOT       DDRTOT
     C                   END

     C     DDPASDok      IFEQ      'N'
     C                   MOVEL     @DDPASD       DDPASD
     C                   END

     C     DDWOFFok      IFEQ      'N'
     C                   MOVEL     @DDWOFF       DDWOFF
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      ***  Inputs
      *
     C                   PARM                    RetCodeIn                      Return Code
     C                   PARM                    NwMaPyScnFmt                   new MR in Screen Fmt
     C                   PARM                    CrMaPyScnFmt                   Cur MR in Screen Fmt
      *
      ***  Outputs
      *
     C                   PARM                    ErrorMapy                      Ok Flags
     C                   PARM                    FldNameArr                     Error Flds
     C                   PARM                    MsgIdArr                             Msg Ids
     C                   PARM                    MsgDtaArr                            Msg Data
     C                   PARM                    Idx
      ***  Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
