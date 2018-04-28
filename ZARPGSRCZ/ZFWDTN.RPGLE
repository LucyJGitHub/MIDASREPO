     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Synon Ver - Calc Working Days Fwd')           *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  ZFWDTN - Calculate Working Days Forward                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR745198A          Date 25Apr11               *
      *  Prev Amend No. AR745198 *CREATE   Date 13Apr11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR745198A - Parameter mismatch on ZFWDT (Child: AR745199)    *
      *  AR745198 - Programs called by ZASDFRBL was amended to improve*
      *             run time of SDC9600 component (Child: AR745199)   *
      *                                                               *
      *****************************************************************
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
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
 
 
     D ZHL1            S              1    DIM(366)
     D ID              S             13A   DIM(500)
     D OD              S              5  0 DIM(500)
 
     D ZHOLDS          DS
     D  DGCYCD                 1      3
     D  DGLCCD                 4      6
     D  DGYRNB                 7     10  0
     D  DGJDNB                11     13P 0
     D  DGDDNB                14     16P 0
     D  ZDS1                  17    202
     D  ZDS2                 203    382
     D  ZHL                   17    382    DIM(366)
 
     D ZVARS           DS
     D  ZIND                   1      1
     D  ZINDX                  2      4  0
     D  ZDAYNO                 5      7P 0
     D  ZDYNBR                 8     10P 0
     D  ZNRDYS                11     12  0
     D  @ZWRDY                13     14  0
 
     D  ZCCY                  15     17
     D  ZLOC                  18     20
     D  @ZWRKI                15     20
 
     D  ZSCCY                 21     23
     D  ZSLOC                 24     26
     D  ZSWEXX                27     30  0
     D  ZSJAN                 31     33P 0
     D  ZSDCM                 34     36P 0
     D  RTNCD                 37     43
     D  @ZWRKO                21     43
      *
     D  ZOPTN                 44     50
     D  ZZCCY                 51     53
     D  ZZLOC                 54     56
     D  ZZDYNO                57     59P 0
     D  ZSRTN                 60     66
 
     D                 DS
     D  IDET                   1     13
     D  IDAYNO                 1      5  0
     D  INRDYS                 6      7  0
     D  ICCY                   8     10
     D  ILOC                  11     13
 
     D PNRDYS          S              2  0                                                 AR745198A
                                                                                           AR745198A
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
 
      ** In Details
 
     C                   Z-ADD     DAYNO         IDAYNO
     C                   Z-ADD     NRDYS         INRDYS
     C                   MOVEL     CCY           ICCY
     C                   MOVEL     LOC           ILOC
 
     C                   Z-ADD     1             XX                3 0
     C     IDET          LOOKUP    ID(XX)                                 99
 
     C                   IF        *IN99 = *ON
     C                   Z-ADD     OD(XX)        DYNBR
     C                   ELSE
 
     C                   Z-ADD     1             XX
     C     *BLANK        LOOKUP    ID(XX)                                 99
     C                   MOVEL     IDET          ID(XX)
     C                   Z-ADD     DAYNO         ZDAYNO
     C                   Z-ADD     NRDYS         ZNRDYS
     C                   Z-ADD     NRDYS         PNRDYS                                    AR745198A
     C                   Z-ADD     0             ZDYNBR
     C                   MOVEL     CCY           ZCCY
     C                   MOVEL     LOC           ZLOC
 
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO
     C**********         PARM                    ZNRDYS                                    AR745198A
     C                   PARM                    PNRDYS                                    AR745198A
     C                   PARM                    ZDYNBR
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
 
     C                   Z-ADD     ZDYNBR        DYNBR
     C                   Z-ADD     ZDYNBR        OD(XX)
 
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      *****************************************************************
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
 
     C     *ENTRY        PLIST
     C                   PARM                    DAYNO             5 0
     C                   PARM                    NRDYS             2 0
     C                   PARM                    DYNBR             5 0
     C                   PARM                    CCY               3
     C                   PARM                    LOC               3
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2011
