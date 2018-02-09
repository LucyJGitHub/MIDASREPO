     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Prices Default, if EXTEL is on')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEPRCSDFT - Default in the values for the EXTEL file         *
      *              EXVALD if EXTEL is on, if the price type is      *
      *              'V'.                                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP060  *CREATE    Date 07Nov00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation on Savings Income (Recompile)              *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAP060 - Conversion of Midas Screen Input Program into full  *
      *           API, including repair program which CAP030 does not *
      *           include                                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
     FEXVALDL1  IF   E           K DISK    INFSR(*PSSR)
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
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the GL standard declares
     D/COPY GLCPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
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
 
     D PRCSFilFmt    E DS                  EXTNAME(PRICED)
     D FL_RECI       E                     EXTFLD(RECI)
      ** Price record in File Format
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Ix              S              3P 0
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *  EXTEL fields should be defaulted to the screen if:
      *  the price type is V
      *  the EXTEL interface has been switched on.
      *  Whether values have already been entered into these fields is handled in SIN/CTL
 
     C                   IF          DDPPRT = 'V'  AND
     C                               BVEXOP = 'Y'
 
     C                   EXSR      SRDEFLT
     C                   RETURN
 
     C                   ELSE
 
     C                   RETURN
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRDEFLT - Routine to output defaults for EXTEL
      *****************************************************************
     C     SRDEFLT       BEGSR
 
     C     DDPSSN        CHAIN     EXVALDF
 
     C                   IF        %FOUND
      *
      * Price Source
      * ------------
     C                   MOVE      PSRC          DDPSRC
      *
      * Auto Price
      * ----------
      ** Move the auto price indicator from PF/EXVALD to the
      **   screen field.
      *
     C                   MOVE      EXAP          DDAPND
      *
      * Lower Price
      * -----------
      ** Reformat the lower price boundary from PF/EXVALD for
      **   output to the screen.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      LPBD          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   MOVE      ZFIELD        DDLPRI
      *
      * Upper Price
      * -----------
      ** Reformat the upper price boundary from PF/EXVALD for
      **   output to the screen.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      UPBD          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   MOVE      ZFIELD        DDUPRI
 
      *
      * Percentage
      * ----------
      ** Reformat the percentage allowable from PF/EXVALD for
      **   output to the screen.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      PMOV          ZFIELD
     C                   Z-ADD     6             ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   MOVE      ZFIELD        DDPCEN
     C                   ENDIF
 
     C                   IF        Not %FOUND AND
     C                             DDACTN = 'E'
      *
      *  If the record is already purged and Enquiry requested,
      *  then display error message and deny the request.
      *
     C                   MOVEL     'N'           OKPSSN            1
     C                   ADD       1             IX
     C                   EVAL      FldNameArr(Ix)  = 'DDPSSN'
     C                   EVAL      MsgIdArr(Ix)  = 'MMA1143'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Return Code
     C                   PARM                    RetCodeIn
      ** Action Code
     C                   PARM                    DDACTN            1
      ** Security Shortname
     C                   PARM                    DDPSSN           10
      ** Price Type
     C                   PARM                    DDPPRT            2
      * Account in file format
     C                   PARM                    PRCSFilFmt
      *
      ** ICD
      *
     C                   PARM                    BVEXOP            1
      * OUTPUTS
      * Screen Output
      *
      ** Price Source
     C                   PARM                    DDPSRC            1
      ** Auto-Price Indicator
     C                   PARM                    DDAPND            1
      ** Lower Price Boundary
     C                   PARM                    DDLPRI           16
      ** Upper Price Boundary
     C                   PARM                    DDUPRI           16
      ** Percentage
     C                   PARM                    DDPCEN           10
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
      *
     C                   PARM                    Ix
      ** OK flags
     C                   PARM                    OKPSSN            1
 
 
      *  Move program name into *LDA field.
     C     *LOCK         In        LDA
     C                   Movel     'SEPRCSDFT'   DBPGM
     C                   Out       LDA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
