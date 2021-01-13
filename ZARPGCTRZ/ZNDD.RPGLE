     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Determine next dividend date')                *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading                                     *
      *                                                               *
      *  ZNDD - Deterime Next Dividend Date                           *
      *                                                               *
      *  Function:  This module computes for the Next Dividend Date   *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZNDDZ1        *
      *  subroutine.  The subroutine consists of one /COPY members.   *
      *  Each of these has been converted to ILE RPG and copied into  *
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
      *                                                               *
      *  The existing code has not been changed except:               *
      *  - to remove dead lines                                       *
      *  - to convert a couple of EXSRs to CALLBs                     *
      *  - Other amendments includes the modification of some fields  *
      *    in the program to contain meaningful names.                *
      *                                                               *
      *  The boundaries of the original /COPY members have been       *
      *  marked, to facilitated future maintenance of both the old    *
      *  members and this one.                                        *
      *                                                               *
      *  If this member has to change, the changes should ALMOST      *
      *  CERTAINLY be implemented by changing the old /COPY member,   *
      *  reconverting it using CVTRPGSRC, and copying it into this    *
      *  member, replacing the existing section and re-changing the   *
      *  EXSRs to CALLBs.                                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL035             Date 01Mar05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSE045             Date 11Sep03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 16Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL035 - EUSD Upgrade to MidasPlus                           *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement.  Field name clash.                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFDDIV     IF   E           K DISK                                         E20085
 
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
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
      *
      ** Rename fields to Avoid conflict with events file
      *
     D  SEC_RECI     E                     EXTFLD(RECI)
     D  SEC_ZZ005    E                     EXTFLD(ZZ005)
     D  SEC_NMCY     E                     EXTFLD(NMCY)
     D  SEC_LCD      E                     EXTFLD(LCD)
     D  SEC_CHTP     E                     EXTFLD(CHTP)
     D  SEC_TNLU     E                     EXTFLD(TNLU)
     D  SEC_FRNT     E                     EXTFLD(FRNT)                                       CSD006
     D  SEC_REPA     E                     EXTFLD(REPA)                                       CSD006
     D  SEC_TMST     E                     EXTFLD(TMST)                                       CSD006
     D  SEC_SEZONE   E                     EXTFLD(SEZONE)                                     CSE045
     D  SEC_SETX     E                     EXTFLD(SETX)                                       CGL035
 
     D CDArr                 183    230
 
      ** Event details
     D FDDIV1        E DS                  EXTNAME(SEDEVD)
 
     D CD              S              4S 0 DIM(12)                              CD01-12 ARRAY
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     ** Inputs
     ** ------
 
     D ECD             S              5P 0
     D BJDFIN          S              1A
 
     ** Output
     ** -----
 
     D NDD             S              5P 0
     D EventPre        S              1A
 
     ** Working Variables
     ** -----------------
 
     D IdX             S              2P 0
 
      ** Working variables for Coupon Date
 
     D IdCTR1          S              2P 0
     D IdCTR2          S              2P 0
     D CpnDtA          S              4A
     D CpnDtN          S              4S 0
 
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
 
 
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ELSE
     C                   SETOFF                                       98
     C                   END
      *
      ** Move the Coupon dates to the Coupon date array
      *
     C                   EVAL      IdCtr2 = 1
 
     C                   DO        12            IdCTr1
     C     4             SUBST     CDArr:Idctr2  CpnDtA
     C                   MOVE (P)  CpnDtA        CpnDtN
     C                   MOVE      CpnDtN        CD(IdCtr1)
     C                   EVAL      IdCtr2 = IdCtr2 + 4
     C                   ENDDO
      *
      ** Perform processing routine
      *
     C                   EXSR      ZNDDZ1
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZNDDZ1 - Main Processing routine                              *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: ZDATE1                                                 *
      *        ZDATE2                                                 *
      *                                                               *
      *****************************************************************
 
      ** +--- The converted ZNDDZ1 starts here ---------------------------+
 
     C     ZNDDZ1        BEGSR
      *
      ** Call ZDATE2 to obtain MMDD for Event Control Date
      *
     C                   Z-ADD     ECD           ZDAYNO
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   MOVEL     ZDATE         ZZECD4            4 0
 
     C     *IN98         IFEQ      '0'
     C                   MOVEL     ZZECD4        ZZWRKD
     C                   MOVE      ZZECD4        ZZWRKM
     C                   Z-ADD     ZZWRKD        ZZECD4
     C                   MOVEL     ZZWRKM        ZZECD4
     C                   END
      *
      ** If date format is DDMMYY convert array of dividend dates to MMDD
      *
     C     *IN98         IFEQ      '0'
     C                   DO        12            IdX
     C                   MOVE      CD(IdX)       ZZWRKM            2 0
     C                   MOVEL     CD(IdX)       ZZWRKD            2 0
     C                   Z-ADD     ZZWRKD        CD(IdX)
     C                   MOVEL     ZZWRKM        CD(IdX)
     C                   END
     C                   END
      *
      ** get year for ECD
      *
     C                   MOVE      ZDATE         ZECDYR            2 0
      *
      ** find Next Dividend Date From Security Diary Events if entered
      *
     C                   Z-ADD     0             NDD
     C                   MOVE      '0'           ZFOUND            1
     C                   MOVE      'N'           EventPre
 
     C     ZKDIV         KLIST
     C                   KFLD                    SESN
     C                   KFLD                    ECD
     C*
     C     ZKDIV         SETLL     SEDEVDF
     C                   READ      SEDEVDF                                99
 
     C     *IN99         IFEQ      '0'
     C     SDSN          ANDEQ     SESN
     C                   MOVE      'Y'           EventPre
     C                   Z-ADD     SDED          NDD
     C                   MOVE      '1'           ZFOUND
     C                   ELSE
      *
      ** Find Next Dividend date from arrays -
      ** If Div dates all blank NDD = 0.
      *
     C                   DO        12            IdX
     C     ZZECD4        IFLE      CD(IdX)
     C                   MOVE      '1'           ZFOUND
     C                   GOTO      ZNDD00
     C                   END
     C                   END
      *
      ** FOUND - Add ECD'S YY to from date
      *
     C     ZNDD00        TAG
     C     ZFOUND        IFEQ      '1'
     C                   Z-ADD     ZECDYR        ZDATE
     C                   MOVEL     CD(IdX)       ZDATE
      *
      ** NOT FOUND - Use first dividend
      **             add next year'S YY to form date
      *
     C                   ELSE
     C                   DO        12            IdX
     C     CD(IdX)       IFNE      0
     C                   Z-ADD     ZECDYR        ZDATE
     C                   ADD       1             ZDATE
     C                   MOVEL     CD(IdX)       ZDATE
     C                   MOVE      '1'           ZFOUND
     C                   GOTO      ZNDD01
     C                   END
     C                   END
     C                   END
     C     ZNDD01        TAG
      *
      ** Convert date to day no using ZDATE1
      ** (not done if no dividend dates found)
      ** if DDMMYY format turn round to MMDDYY
      *
     C     ZFOUND        IFEQ      '1'
 
     C     *IN98         IFEQ      '0'
     C                   MOVEL     ZDATE         ZZWRK             4 0
     C                   MOVE      ZZWRK         ZZWRKM
     C                   MOVEL     ZZWRK         ZZWRKD
     C                   Z-ADD     ZZWRKD        ZZWRK
     C                   MOVEL     ZZWRKM        ZZWRK
     C                   MOVEL     ZZWRK         ZDATE
     C                   END
 
     C                   MOVE      ZDATE         ZDATEA            6
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEA
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
 
     C                   Z-ADD     ZDAYNO        NDD
      *
      ** If next dividend date is less than first expected Dividend Date
      ** then Next Date is First Date
      *
     C     NDD           IFLT      IDIV
     C                   Z-ADD     IDIV          ZDATE
     C                   END
 
     C                   END
      *
      ** If arrays are blank use first expected dividend date
      *
     C     ZFOUND        IFEQ      '0'
     C                   Z-ADD     IDIV          NDD
     C                   END
 
     C                   END
      *
      ** if date format is DDMMYY turn back array of dividend dates to DDMM
      *
     C     *IN98         IFEQ      '0'
     C                   DO        12            IdX               2 0
     C                   MOVEL     CD(IdX)       ZZWRKM            2 0
     C                   MOVE      CD(IdX)       ZZWRKD            2 0
     C                   Z-ADD     ZZWRKM        CD(IdX)
     C                   MOVEL     ZZWRKD        CD(IdX)
     C                   END
     C                   END
 
      ** +--- The converted ZNDDZ1 ends here ---------------------------+
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      * INPUTS
 
      ** Security Details
     C                   PARM                    SECTY
 
      ** Event Control Date (5P 0)
      ** Date format (1A)
     C                   PARM                    ECD
     C                   PARM                    BJDFIN
 
      * OUTPUTS
 
      ** Next Dividend Date (5P 0)
      ** Event found Indicator (1A)
      ** Event Diary Details
     C                   PARM                    NDD
     C                   PARM                    EventPre
     C                   PARM                    FDDIV1
 
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
**  CPY@
(c) Finastra International Limited 2001
