     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR IRC schedule dates for cross ccy swaps')
      *****************************************************************
      *                                                               *
      *  Midas - Common Validation Routine                            *
      *                                                               *
      *  IRCIRSCHD - IRS Schedule dates for IRCs                      *
      *              Cross Currency Swaps                             *
      *                                                               *
      *  Function:  This module receives details of the IRS           *
      *             transaction and displays the schedule dates       *
      *             screens for IRCs, if required.                    *
      *             This module will only be called if the IRC        *
      *             switchable feature is on.                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CDL038             Date 10May05               *
      *                 BUG6472            Date 20Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 198338             Date 03Oct01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 170790             Date 11Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 153675             Date 20Jan99               *
      *                 CAP004  *CREATE    Date 31Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG6472- Added a sign field for short term rate (Recompile)  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CLE025 - Credit Lines                                        *
      *  198338 - No decimals allowed in 'Amount' field in Our/ Their *
      *           Cash Flow Schedule  input-screens, when  Our/ Their *
      *           Int Paym Freq  is  'C'.                             *
      *           Amend the pgm to use  correct value for  WPNBDP ;   *
      *           WRNBDP  &  WNBDP -Number of Decimal places .        *
      *  170790 - Correct ZDATE1/2 parms in IRS data schedule modules *
      *  CIR005 - Business Day Conventions                            *
      *  153675 - Incorrect definition of ZDAYNO (should be 5,0P)     *
      *  CAP004 - Conversion of inputs into modular structure to      *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
     FDLDCPSL0  IF   E           K DISK
     F                                     INFDS(@DLSTS)
      *
     FDLDETDL0  IF   E           K DISK
     F                                     RENAME(DLPCSCD0:DLPCSCD1)
     F                                     RENAME(DLDTSCD0:DLDTSCD1)
     F                                     RENAME(DLCFSCD0:DLCFSCD1)
      *
     FDLDETUL0  UF A E           K DISK
     F                                     RENAME(DLPCSCD0:DLPCSCD2)
     F                                     RENAME(DLDTSCD0:DLDTSCD2)
     F                                     RENAME(DLCFSCD0:DLCFSCD2)
     F                                     COMMIT
      **
      ** +-----------------------------------+
      ** ¦ End of Manually Included F-Specs  ¦
      ** ¦ ================================  ¦
      ** +-----------------------------------+
      **
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D APGM            S              3    DIM(6)
     D ASCH            S              1    DIM(6)
 
      ** Array of warning error message IDs from IRC date schedule screens
     D @WerrAr         S                   DIM(10)
     D                                     LIKE(#MsgID)
 
     D DlScnFmt      E DS                  EXTNAME(IRCIRSPD)
      * Deal in Screen Format
                                                                                CIR005
     D*CcyPayLeg1************243    272                                                CIR005 CLE025
     D CcyPayLeg1            258    287                                                       CLE025
      ** Currencies for Payment Convention - leg 1                              CIR005
                                                                                CIR005
     D*CcyPayLeg2************307    336                                                CIR005 CLE025
     D CcyPayLeg2            322    351                                                       CLE025
      ** Currencies for Payment Convention - leg 2                              CIR005
 
     D*  Currency DS
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * DLDCPSL0 file information data structure
     D @DLSTS          DS
     D  @DLPF                 38     45
      *                                                                         CIR005
      ** Array definition for currencies for payment convention                 CIR005
     D ACcyPay         S              3A   DIM(10)                              CIR005
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      **BJDFIN passed as a parameter to ZDATE1
     D    BJDFIN       S              1A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WONBDP          S                   LIKE(A6NBDP)
     D WTNBDP          S                   LIKE(A6NBDP)
     D WPNBDP          S                   LIKE(A6NBDP)
     D WRNBDP          S                   LIKE(A6NBDP)
     D WRSCY           S              3A
     D WPSCY           S              3A
     D Y               S              1S 0 INZ(1)
     D X               S              1S 0 INZ(0)
 
      * date passed as a parameter to ZDATE1
     D   ZDATEA        S              6A                                                      170790
     D***ZDATE*********S**************6A                                                      170790
      * date passed as a parameter to ZDATE2
     D***ZDAYNO********S              5S 0                                      153675
     D   ZDATE         S              6P 0                                      170790
     D   ZDAYNO        S              5P 0                                      153675
 
      **Error flag returned by ZDATE1
     D   Errorflag     S              1A
 
      **
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
 
      ** Reset fields used
     C                   RESET                   RetCodeOut
     C                   RESET                   Y
      *
      ** If no frequencies set to IRC values, end program
      *
     C     SUICFR        IFNE      'Z'
     C     SUIPFR        ANDNE     'Z'
     C     SUIPFR        ANDNE     'C'
     C     STICFR        ANDNE     'Z'
     C     STIPFR        ANDNE     'Z'
     C     STIPFR        ANDNE     'C'
      *
      ** If mode is backwards, i.e. F12 from window screen, ensure
      ** main screen is redisplayed
      *
     C     MODE          IFEQ      'B'
     C                   EVAL      RetCodeOut = 'USR0790'
     C                   ENDIF
     C                   GOTO      NOSCHED
     C                   ENDIF
      *
      ** If mode is backwards, i.e. F12 from window screen, reset values
      ** to display last screen first
      *
     C     MODE          IFEQ      'B'
     C                   MOVE      APGM(X)       WPGM
     C                   MOVE      *BLANK        APGM(X)
     C                   SUB       1             X
     C                   ELSE
     C                   MOVE      *BLANK        ASCH
     C                   RESET                   X
     C                   ENDIF
      *
      ** Get dec places for relevant currencies
      *
     C                   EXSR      CURRS
 
     C                   MOVE      'N'           VALID             1
     C                   MOVE      *BLANKS       PRTCD
     C                   MOVEL     SVDAT         CVDAT
     C                   MOVEL     SMDAT         CMDAT
     C     SDLNO         IFNE      *BLANK
     C                   MOVE      SDLNO         @DLNUM            6 0
     C                   ELSE
     C                   MOVE      I#SDLNO       @DLNUM
     C                   ENDIF
     C*
     C     VALID         DOWNE     'Y'
     C     PRTCD         ANDNE     'Y2U9999'
     C*
     C** Our rate change date schedule
     C*
     C                   SELECT
     C     SUICFR        WHENEQ    'Z'
     C     ASCH(1)       ANDNE     'Y'
     C     WPGM          OREQ      1
     C                   MOVEL     'R'           RCIP
     C                   MOVEL     SUNICD        CTLDAT
     C                   MOVEL     'U'           OTIN
     C                   MOVEL     SUCUCY        CCCY
     C                   MOVEL     WONBDP        WNBDP
     C                   MOVEA     CcyPayLeg1    ACcyPay                        CIR005
     C                   EXSR      DATESCH
     C                   Z-ADD     1             Z                 1 0
     C                   MOVE      'Y'           ASCH(1)
     C*
     C** Date changed
     C*
     C     CTLDAT        IFNE      SUNICD
     C                   MOVEA     'MMA0600'     @WerrAr(Y)
     C                   ADD       1             Y
     C                   MOVEL     CTLDAT        SUNICD
     C                   END
     C*
     C** Our cash flow schedule
     C*
     C     SUIPFR        WHENEQ    'C'
     C     ASCH(2)       ANDNE     'Y'
     C     WPGM          OREQ      2
     C                   MOVEL     SUNIPD        CTLDAT
     C                   MOVEL     'U'           OTIN
     C                   MOVEL     WPSCY         CCCY
     C                   MOVEL     WPNBDP        WNBDP
     C                   EXSR      CASHSCH
     C*******************MOVE      NVDAT         ZDATE                                        170790
     C                   MOVE      NVDAT         ZDATEA                                       170790
     C                   CALLB     'ZDATE1'
     C*******************PARM                    ZDATE                                        170790
     C                   PARM                    ZDATEA                                       170790
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    Errorflag
     C     Errorflag     IFNE      'Y'
     C                   MOVE      ZDAYNO        WUVDAT            5 0
     C                   END
     C                   Z-ADD     CFLA          WUCFLA           13 0
     C                   Z-ADD     2             Z
     C                   MOVE      'Y'           ASCH(2)
     C*
     C** Date changed
     C*
     C     NVDAT         IFNE      SUNIPD
     C                   MOVEA     'MMA0601'     @WerrAr(Y)
     C                   ADD       1             Y
     C                   MOVEL     NVDAT         SUNIPD
     C                   END
     C*
     C** Our payment date schedule
     C*
     C     SUIPFR        WHENEQ    'Z'
     C     ASCH(3)       ANDNE     'Y'
     C     WPGM          OREQ      3
     C                   MOVEL     'P'           RCIP
     C                   MOVEL     SUNIPD        CTLDAT
     C                   MOVEL     'U'           OTIN
     C                   MOVEL     WPSCY         CCCY
     C                   MOVEL     WPNBDP        WNBDP
     C                   MOVEA     CcyPayLeg1    ACcyPay                        CIR005
     C                   EXSR      DATESCH
     C                   Z-ADD     3             Z
     C                   MOVE      'Y'           ASCH(3)
     C*
     C** Date changed
     C*
     C     CTLDAT        IFNE      SUNIPD
     C                   MOVEA     'MMA0601'     @WerrAr(Y)
     C                   ADD       1             Y
     C                   MOVEL     CTLDAT        SUNIPD
     C                   END
     C*
     C*
     C** Their rate change date schedule
     C*
     C     STICFR        WHENEQ    'Z'
     C     ASCH(4)       ANDNE     'Y'
     C     WPGM          OREQ      4
     C                   MOVEL     'R'           RCIP
     C                   MOVEL     STNICD        CTLDAT
     C                   MOVEL     'T'           OTIN
     C                   MOVEL     STCUCY        CCCY
     C                   MOVEL     WTNBDP        WNBDP
     C                   MOVEA     CcyPayLeg2    ACcyPay                        CIR005
     C                   EXSR      DATESCH
     C                   Z-ADD     4             Z
     C                   MOVE      'Y'           ASCH(4)
     C*
     C** Date changed
     C*
     C     CTLDAT        IFNE      STNICD
     C                   MOVEA     'MMA0602'     @WerrAr(Y)
     C                   ADD       1             Y
     C                   MOVEL     CTLDAT        STNICD
     C                   END
     C*
     C** Their cash flow schedule
     C*
     C     STIPFR        WHENEQ    'C'
     C     ASCH(5)       ANDNE     'Y'
     C     WPGM          OREQ      5
     C                   MOVEL     STNIPD        CTLDAT
     C                   MOVEL     'T'           OTIN
     C                   MOVEL     WRSCY         CCCY
     C                   MOVEL     WRNBDP        WNBDP
     C                   EXSR      CASHSCH
     C*******************MOVE      NVDAT         ZDATE                                        170790
     C                   MOVE      NVDAT         ZDATEA                                       170790
     C                   CALLB     'ZDATE1'
     C*******************PARM                    ZDATE                                        170790
     C                   PARM                    ZDATEA                                       170790
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    Errorflag
     C     Errorflag     IFNE      'Y'
     C                   MOVE      ZDAYNO        WTVDAT            5 0
     C                   END
     C                   Z-ADD     CFLA          WTCFLA           13 0
     C                   Z-ADD     5             Z
     C                   MOVE      'Y'           ASCH(5)
     C*
     C** Date changed
     C*
     C     NVDAT         IFNE      STNIPD
     C                   MOVEA     'MMA0603'     @WerrAr(Y)
     C                   ADD       1             Y
     C                   MOVEL     NVDAT         STNIPD
     C                   END
     C*
     C** Their payment date schedule
     C*
     C     STIPFR        WHENEQ    'Z'
     C     ASCH(6)       ANDNE     'Y'
     C     WPGM          OREQ      6
     C                   MOVEL     'P'           RCIP
     C                   MOVEL     STNIPD        CTLDAT
     C                   MOVEL     'T'           OTIN
     C                   MOVEL     WRSCY         CCCY
     C                   MOVEL     WRNBDP        WNBDP
     C                   MOVEA     CcyPayLeg2    ACcyPay                        CIR005
     C                   EXSR      DATESCH
     C                   Z-ADD     6             Z
     C                   MOVE      'Y'           ASCH(6)
     C*
     C** Date changed
     C*
     C     CTLDAT        IFNE      STNIPD
     C                   MOVEA     'MMA0603'     @WerrAr(Y)
     C                   ADD       1             Y
     C                   MOVEL     CTLDAT        STNIPD
     C                   END
     C*
     C                   OTHER
     C                   MOVE      'Y'           VALID
     C                   ENDSL
     C*
     C     PRTCD         IFEQ      'USR0790'
     C                   MOVE      *BLANKS       ASCH(Z)
     C     X             IFGE      1
     C                   MOVE      APGM(X)       WPGM              1 0
     C                   MOVE      *BLANKS       APGM(X)
     C                   SUB       1             X
     C                   ELSE
     C                   Z-ADD     0             WPGM
     C                   LEAVE
     C                   END
     C                   END
     C*
     C     PRTCD         IFEQ      *BLANKS
     C     VALID         ANDNE     'Y'
     C                   ADD       1             X
     C                   MOVE      Z             APGM(X)
     C                   Z-ADD     0             WPGM
     C                   END
      *
     C                   END
      *
     C                   EVAL      RetCodeOut = PRTCD
     C*
     C** If still no errors
     C** Check:
     C**  1.For interest payments, rate changes, cash flows or principal
     C**    changes falling before value date or after maturity date
     C**  2.If interest is up front, rate changes must fall on interest
     C**    payment dates
     C*
     C     Y             IFEQ      1
     C                   EXSR      VALDATS
     C                   END
      *
      * No IRC schedule processing required
      *
     C     NOSCHED       TAG
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  DATESCH - Date Schedule Input                                *
     C*                                                               *
     C*  Called by  : SCHEDULE - Other Schedule Input                 *
     C*                                                               *
     C*  Calls      : DL4000   - Date Schedule Maintenance            *
     C*                                                               *
     C*****************************************************************
     C     DATESCH       BEGSR
     C*
     C                   CALL      'DL4000'
     C                   PARM                    @DLNUM
     C                   PARM                    SDTYP
     C                   PARM                    OTIN              1
     C                   PARM                    RCIP              1
     C                   PARM                    CTLDAT            6
     C                   PARM                    CVDAT             6
     C                   PARM                    CMDAT             6
     C                   PARM                    CCCY              3
     C                   PARM      SACCD         PSCD              1
     C                   PARM                    PRTCD             7
     C                   PARM                    ACcyPay                        CIR005
     C*
     C                   ENDSR
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  CASHSCH - Cash Flow Schedule Input                           *
     C*                                                               *
     C*  Called by  : SCHEDULE - Other Schedule Input                 *
     C*                                                               *
     C*  Calls      : DL4010   - Cash Flow Schedule Maintenance       *
     C*                                                               *
     C*****************************************************************
     C     CASHSCH       BEGSR
     C*
     C                   CALL      'DL4010'
     C                   PARM                    @DLNUM
     C                   PARM                    SDTYP
     C                   PARM                    OTIN              1
     C                   PARM                    CTLDAT            6
     C                   PARM                    CVDAT             6
     C                   PARM                    CMDAT             6
     C                   PARM                    CCCY              3
     C                   PARM                    WNBDP             1 0
     C                   PARM                    CFLA             13 0
     C                   PARM                    NVDAT             6
     C                   PARM      SACCD         PSCD              1
     C                   PARM                    PRTCD             7
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  VALDATS - Validate Schedule Dates                            *
     C*                                                               *
     C*  Called by  : SCHEDULE - Other Schedule Input                 *
     C*                                                               *
     C*  Calls      : DELSCH   - Delete Schedule Record               *
     C*                                                               *
     C*****************************************************************
     C     VALDATS       BEGSR
     C*
     C** Reset principal change, date schedule and cash flow error inds
     C*
     C                   MOVEL     *BLANK        DTSHER            1
     C                   MOVEL     *BLANK        CSFLER            1
     C*
     C     KIRDTX        SETLL     DLDCPSL0
     C                   MOVEL     *BLANK        OTIN
     C                   MOVEL     *BLANK        RCIP
     C     KIRDTX        READE     DLDCPSL0                               99
     C*
     C** Read all records from DLDETUL0 for this deal
     C*
     C     *IN99         DOWEQ     '0'
     C*
     C** Date on record must not be:
     C** - prior to value date of deal if it is an interest payment
     C** - or prior to or at value date otherwise
     C** If it is, then delete it and issue warning message
     C*
     C     PRDT          IFLT      VDATX
     C     @DLPF         ANDEQ     'DLDTSCD0'
     C     RCIP          ANDEQ     'P'
     C     PRDT          ORLE      VDATX
     C     @DLPF         ANDEQ     'DLDTSCD0'
     C     RCIP          ANDEQ     'R'
     C     PRDT          ORLE      VDATX
     C     @DLPF         ANDNE     'DLDTSCD0'
     C                   EXSR      DELSCHD
      * Old W10 warning error message
     C                   MOVEA     'MMA0604'     @WerrAr(Y)
     C                   ADD       1             Y
     C                   END
     C*
     C** Date on record must not be:
     C** - after maturity date of deal if it is a cash flow record
     C**   or an interest payment record
     C** - or after or at maturity date otherwise
     C** If it is, then delete it and issue warning message
     C*
     C     PRDT          IFGT      MDATX
     C     @DLPF         ANDEQ     'DLCFSCD0'
     C     PRDT          ORGT      MDATX
     C     @DLPF         ANDEQ     'DLDTSCD0'
     C     RCIP          ANDEQ     'P'
     C     PRDT          ORGE      MDATX
     C     @DLPF         ANDEQ     'DLDTSCD0'
     C                   EXSR      DELSCHD
      * Old W11 warning error message
     C                   MOVEA     'MMA0605'     @WerrAr(Y)
     C                   ADD       1             Y
     C                   END
     C                   MOVEL     *BLANK        OTIN
     C                   MOVEL     *BLANK        RCIP
     C     KIRDTX        READE     DLDCPSL0                               99    *
     C                   END
     C*
     C** If any errors have been found recalculate the 'next' dates
     C** (ie our/their next interest payment and rate change dates)
     C*
     C** Error in cash flow schedule
     C*
     C     CSFLER        IFEQ      'Y'
     C*
     C** 'OUR' cash flow
     C*
     C     SUIPFR        IFEQ      'C'
     C                   MOVEL     'U'           OTIN
     C     KCSFL         SETLL     DLCFSCD1
     C*
     C** Next date is first 'non-processed' record on DLCFSCPD
     C*
     C     KCSFL         READE     DLCFSCD1                               99    *
     C     *IN99         IFEQ      '0'
     C                   CALLB     'ZDATE2'
     C                   PARM      PRDT          ZDAYNO                         Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE                          Value date
     C                   PARM      *BLANKS       ZADATE            7            Run-date in DDM
     C                   MOVE      ZDATE         SUNIPD
     C                   ELSE
     C                   MOVEL     *BLANK        SUNIPD
     C                   END
     C                   END
     C*
     C** 'THEIR' cash flow
     C*
     C     STIPFR        IFEQ      'C'
     C                   MOVEL     'T'           OTIN
     C     KCSFL         SETLL     DLCFSCD1
     C*
     C** Next date is first 'non-processed' record on DLCFSCPD
     C*
     C     KCSFL         READE     DLCFSCD1                               99    *
     C     *IN99         IFEQ      '0'
     C                   CALLB     'ZDATE2'
     C                   PARM      PRDT          ZDAYNO                         Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE                          Value date
     C                   PARM      *BLANKS       ZADATE            7            Run-date in DDM
     C                   MOVE      ZDATE         STNIPD
     C                   ELSE
     C                   MOVEL     *BLANK        STNIPD
     C                   END
     C                   END
     C                   END
     C*
     C** Error in date schedule
     C*
     C     DTSHER        IFEQ      'Y'
     C*
     C** 'OUR' rate change
     C*
     C     SUICFR        IFEQ      'Z'
     C                   MOVEL     'U'           OTIN
     C                   MOVEL     'R'           RCIP
     C     KDTSCH        SETLL     DLDTSCD1
     C*
     C** Next date is first 'non-processed' record on DLDTSCPD
     C*
     C     KDTSCH        READE     DLDTSCD1                               99    *
     C     *IN99         IFEQ      '0'
     C                   CALLB     'ZDATE2'
     C                   PARM      PRDT          ZDAYNO                         Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE                          Value date
     C                   PARM      *BLANKS       ZADATE            7            Run-date in DDM
     C                   MOVE      ZDATE         SUNICD
     C                   ELSE
     C                   MOVEL     *BLANK        SUNICD
     C                   END
     C                   END
     C*
     C** 'OUR' interest payment
     C*
     C     SUIPFR        IFEQ      'Z'
     C                   MOVEL     'U'           OTIN
     C                   MOVEL     'P'           RCIP
     C     KDTSCH        SETLL     DLDTSCD1
     C*
     C** Next date is first 'non-processed' record on DLDTSCPD
     C*
     C     KDTSCH        READE     DLDTSCD1                               99    *
     C     *IN99         IFEQ      '0'
     C                   CALLB     'ZDATE2'
     C                   PARM      PRDT          ZDAYNO                         Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE                          Value date
     C                   PARM      *BLANKS       ZADATE            7            Run-date in DDM
     C                   MOVE      ZDATE         SUNIPD
     C                   ELSE
     C                   MOVEL     *BLANK        SUNIPD
     C                   END
     C                   END
     C*
     C** 'THEIR' rate change
     C*
     C     STICFR        IFEQ      'Z'
     C                   MOVEL     'T'           OTIN
     C                   MOVEL     'R'           RCIP
     C     KDTSCH        SETLL     DLDTSCD1
     C*
     C** Next date is first 'non-processed' records on DLDTSCPD
     C*
     C     KDTSCH        READE     DLDTSCD1                               99    *
     C     *IN99         IFEQ      '0'
     C                   CALLB     'ZDATE2'
     C                   PARM      PRDT          ZDAYNO                         Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE                          Value date
     C                   PARM      *BLANKS       ZADATE            7            Run-date in DDM
     C                   MOVE      ZDATE         STNICD
     C                   ELSE
     C                   MOVEL     *BLANK        STNICD
     C                   END
     C                   END
     C*
     C** 'THEIR' interest payment
     C*
     C     STIPFR        IFEQ      'Z'
     C                   MOVEL     'T'           OTIN
     C                   MOVEL     'P'           RCIP
     C     KDTSCH        SETLL     DLDTSCD1
     C*
     C** Next date is first 'Non-processed' record on DLDTSCPD
     C*
     C     KDTSCH        READE     DLDTSCD1                               99    *
     C     *IN99         IFEQ      '0'
     C                   CALLB     'ZDATE2'
     C                   PARM      PRDT          ZDAYNO                         Value date
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM      *ZEROS        ZDATE                          Value date
     C                   PARM      *BLANKS       ZADATE            7            Run-date in DDM
     C                   MOVE      ZDATE         STNIPD
     C                   ELSE
     C                   MOVEL     *BLANK        STNIPD
     C                   END
     C                   END
     C*
     C                   END
     C     EVALSD        ENDSR
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  DELSCHD - Delete Schedule Record                             *
     C*                                                               *
     C*  Called by  : VALSCHD - Validate Schedule Dates               *
     C*                                                               *
     C*  Calls      :                                                 *
     C*                                                               *
     C*****************************************************************
     C     DELSCHD       BEGSR
     C*
     C     @DLPF         IFEQ      'DLDTSCD0'
     C     KIRSDT        CHAIN     DLDTSCD2                           99        *
     C  N99              DELETE    DLDTSCD2
     C  N99              MOVEL     'Y'           DTSHER
     C                   ELSE
     C*
     C     KIRSCF        CHAIN     DLCFSCD2                           99        *
     C  N99              DELETE    DLCFSCD2
     C  N99              MOVEL     'Y'           CSFLER
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  CURRS - Access currency details and set up work fields       *
     C*                                                               *
     C*  Called by  : MAIN                                            *
     C*                                                               *
     C*  Calls      :                                                 *
     C*                                                               *
     C*****************************************************************
     C     CURRS         BEGSR
      *
      ** Get decimal places for currencies, Ours and Theirs (RX only)
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SUCUCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   MOVE      A6NBDP        WONBDP
 
     C     SDTYP         IFEQ      'RX'
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      STCUCY        @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   MOVE      A6NBDP        WTNBDP
     C                   ENDIF
      *
      ** Get decimal places for settlement currencies, if used
      *
     C     SPSCY         IFNE      *BLANK
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      SPSCY         @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   MOVE      A6NBDP        WPNBDP
     C                   MOVE      SPSCY         WPSCY
     C                   ELSE
     C                   MOVE      SUCUCY        WPSCY
     C                   MOVE      WONBDP        WPNBDP                                       198338
     C                   ENDIF
      *
     C     SRSCY         IFNE      *BLANK
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      SRSCY         @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   MOVE      A6NBDP        WRNBDP
     C                   MOVE      SRSCY         WRSCY
     C                   ELSE
     C                   MOVE      STCUCY        WRSCY
     C                   MOVE      WTNBDP        WRNBDP                                       198338
     C                   ENDIF
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    Mode              1
     C                   PARM                    DlScnFmt
     C                   PARM                    I#SDLNO           6
     C                   PARM                    SRSCY             3
     C                   PARM                    SPSCY             3
     C                   PARM                    MDATX             5 0
     C                   PARM                    VDATX             5 0
     C                   PARM                    BJDFIN
     C                   PARM                    @WerrAr
      *
     C     KIRDTX        KLIST
     C                   KFLD                    @DLNUM
     C* CHAIN-DT
     C     KIRSDT        KLIST
     C                   KFLD                    @DLNUM
     C                   KFLD                    OTIN
     C                   KFLD                    RCIP
     C                   KFLD                    PRDT
     C* CHAIN-CF
     C     KIRSCF        KLIST
     C                   KFLD                    @DLNUM
     C                   KFLD                    OTIN
     C                   KFLD                    PRDT
     C* READE-DT
     C     KDTSCH        KLIST
     C                   KFLD                    @DLNUM
     C                   KFLD                    OTIN
     C                   KFLD                    RCIP
     C* READE-CF
     C     KCSFL         KLIST
     C                   KFLD                    @DLNUM
     C                   KFLD                    OTIN
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
