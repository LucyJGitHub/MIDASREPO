     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate CUTYPE Customer Type')
      *****************************************************************
      *                                                               *
      *  Midas - IBLC 2002 Module                                     *
      *                                                               *
      *  SDVCUTYPE2 - Validate Customer Type                          *
      *                                                               *
      *  Function:  This module receives a parameter containing a     *
      *             customer type, and confirms wether it is a valid  *
      *             customer type or not.                             *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  Component of:  SP121CTYLX - Core Luxembourg service program  *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03May06               *
      *                 CER001             Date 25Apr05               *
      *                 ULX043             Date 03Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking                                    *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  ULX043 - IBLC 2002 Reporting                                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     F***SDCUSTX6  IF   E           K DISK    INFSR(*PSSR)                                    CER001
      *Extended Customer details                                  Prefix VF.
     F***SDCTRYXL  IF   E           K DISK    INFSR(*PSSR)                                    CER001
     FSDCTX1PD  IF   E           K DISK    INFSR(*PSSR)                                       CER001
      *Extended Customer details                                  Prefix VF.
     FSDBRCHL5  IF   E           K DISK    INFSR(*PSSR)
      *Extended Branch details                                    Prefix A8.
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
 
      ** Input array
     D CTR             S              2    DIM(8) CTDATA PERRCD(8)
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
     D #LLXTYPE        S              2A
     D #1colc          S              2A
     D #1cust          S              6A
     D #1bnbi          S              1A
     D #1brcd          S              3A
     D BRBKCO          S              2S 0
     D VFNCOS          S              4  0                                                    CER001
     D #1NCOS          S              4                                                       CER001
 
      ** Define working fields
     D KICICDR         S              2A                                        ICDR ID
     D KBRCH           S              3A                                        Branch code
     D KBKCO           S              2S 0                                      IBLC Bank Country
     D KBANK           S              2A                                        Bank Country
     D KTYPE           S              1A
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ***
      ***  Initial processing is performed automatically: the *INZSR is
      ***  executed at program activation.
      ***
      *
      ***  Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
     C                   RESET                   DBErrFound
      *
     C     #LLXTYPE      IFNE      *BLANKS
      *
     C                   MOVE      *OFF          *IN99
     C     #LLXTYPE      IFEQ      'R '                                                       CRE026
     C                   EVAL      #LLXTYPE = ' R'                                            CRE026
     C                   ENDIF                                                                CRE026
     C     #LLXTYPE      IFEQ      'O '                                                       CRE026
     C                   EVAL      #LLXTYPE = ' O'                                            CRE026
     C                   ENDIF                                                                CRE026
     C     #LLXTYPE      LOOKUP    CTR                                    99
     C     *IN99         IFEQ      '0'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL01101'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
 
     C                   MOVE      #LLXTYPE      KTYPE
      *
      ***  Verify if customer is or not resident
      *
     C     #1COLC        IFEQ      'LU'
      *
      ***  Customer resident defined as non- resident
      *
     C     KTYPE         IFNE      'R'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL01102'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
 
     C                   ELSE
      *
      ***  Customer non-resident defined as resident
      *
     C     KTYPE         IFEQ      'R'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL01103'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
 
     C                   ENDIF                                                  Not 'LU'
      *
      ***  Does Customer be a bank ?
      *
     C                   MOVEL     #LLXTYPE      WWTYP2            1
      *
     C     #1CUST        SETLL     SDBRCHL5                               62
      *
     C     #1BNBI        IFEQ      'Y'
     C     *IN62         OREQ      *ON
      *
      ***  Bank defined as a non-Bank
      *
     C     WWTYP2        IFNE      'B'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL01104'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  Non-Bank defined as a Bank
      *
     C     #1BNBI        IFEQ      'N'
      *
     C     WWTYP2        IFEQ      'B'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL01105'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  Create CUTYPE
      *
     C                   ELSE
      *
      ***  Does customer be a bank ?
      *
     C     #1BNBI        IFEQ      'Y'
     C                   SELECT
     C     #1COLC        WHENEQ    'LU'
     C                   MOVE      'BR'          #LLXTYPE
     C                   OTHER
     C                   MOVE      'BO'          #LLXTYPE
     C                   ENDSL
     C                   ELSE
      *
      ***  use Economic code VFNCOS from SDCUSTX6 to determinate organism
      *
     C*****#1CUST        CHAIN     SDCUSTX6                           88                      CER001
     C******IN88         IFEQ      *ON                                                        CER001
     C**********         MOVEL     'SDCUSTX6'    DBFILE                                       CER001
     C**********         MOVEL     '008'         DBASE                                        CER001
     C**********         MOVEL     *BLANKS       DBKEY                                        CER001
     C**********         MOVEL     #1CUST        DBKEY                                        CER001
     C**********         EXSR      *PSSR                                                      CER001
     C**********         ELSE                                                                 CER001
      *
     C                   SELECT
      *
      ***  OPCVM
      *
     C     VFNCOS        WHENEQ    6101
     C     VFNCOS        OREQ      6121
     C                   SELECT
     C     #1COLC        WHENEQ    'LU'
     C                   MOVE      'OR'          #LLXTYPE
     C                   OTHER
     C                   MOVE      'OO'          #LLXTYPE
     C                   ENDSL
      *
      ***  ADM. PUBL.
      *
     C     VFNCOS        WHENEQ    2001
     C     VFNCOS        OREQ      2002
     C     VFNCOS        OREQ      2003
     C     VFNCOS        OREQ      2004
     C     VFNCOS        OREQ      2005
     C     VFNCOS        OREQ      2006
     C     VFNCOS        OREQ      2007
     C     VFNCOS        OREQ      2008
     C     VFNCOS        OREQ      2101
     C     VFNCOS        OREQ      2102
     C     VFNCOS        OREQ      2150
     C     VFNCOS        OREQ      2151
     C     VFNCOS        OREQ      2201
     C     VFNCOS        OREQ      2202
     C     VFNCOS        OREQ      2300
     C     VFNCOS        OREQ      2400
      *
     C                   SELECT
     C     #1COLC        WHENEQ    'LU'
     C                   MOVE      'AR'          #LLXTYPE
     C                   OTHER
     C                   MOVE      'AO'          #LLXTYPE
     C                   ENDSL
      *
      ***  OTHER
      *
     C                   OTHER
     C                   SELECT
     C     #1COLC        WHENEQ    'LU'
     C                   MOVE      ' R'          #LLXTYPE
     C                   OTHER
     C                   MOVE      ' O'          #LLXTYPE
     C                   ENDSL
      *
     C                   ENDSL
      *
     C**********         ENDIF                                                                CER001
      *
     C                   ENDIF
      *
     C                   ENDIF                                                  End blank
      *
      ***  If an error was found, set the return code appropriately
      *
     C     #ERROR        TAG
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
 
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ***  Parameters
      *
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    #LLXTYPE
     C                   PARM                    #1COLC
     C                   PARM                    #1CUST
     C                   PARM                    #1BNBI
     C                   PARM                    #1BRCD
     C                   PARM                    BRBKCO
     C                   PARM                    #1NCOS                                       CER001
      *                                                                                       CER001
     C                   MOVEL     #1NCOS        VFNCOS                                       CER001
      *
      ***  Set the program, module and procedure names for database
      ***  error processing.  Note: this /COPY requires that the PSDS
      ***  /COPY is also included.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Program, module and procedure names for database error process*
      *                                                               *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
** CTR Benef/ordering type
BRBOOROOARAO R O
