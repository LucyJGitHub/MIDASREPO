     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SF Menu Items Extract')
      *****************************************************************
      *                                                               *
      *  Midas - Security Profile Facility                            *
      *                                                               *
      *  SF000030 - Midas SF Menu Items Extract                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 240985             Date 13Jul06               *
      *  Prev Amend No. BUG8922            Date 14Jun06               *
      *                 BUG2975            Date 28May04               *
      *                 BUG2711 *CREATE    Date 26May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  240985 - Database error 101 in file SFMNUIPD, within program *
      *           SF000020. Reversed part of fix BUG8922 and passed   *
      *           the user's security level value from SF000020.      *
      *  BUG8922 - Cannot authorise to menu codes that don't appear   *
      *            in any menu                                        *
      *  BUG2975 - Security Profile Facility changes for MidasPlus    *
      *  BUG2711 - Security Profile Facility changes for MidasPlus    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSFMNUUL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SF Menu Users File by SFUUSR
 
     FSFMNUHL1  IF   E           K DISK    INFSR(*PSSR)
      ***Midas*SF*Menu*Hierarchy*File*by*SFHUSR/SFHMSN/SFHMTP***********                     BUG2975
      ** Midas SF Menu Hierarchy File by SFHMSN/SFHMTP                                       BUG2975
 
     FSFMNULL1  IF   E           K DISK
      ** Midas SF Menu Links File by SFLHID
 
     FSFMNUIPD  O    E             DISK
      ** Midas SF Menu Items Extract File
 
     FSFMNUIL1  IF   E           K DISK    Rename(SFMNUID0:SFMNUID1)                         BUG8922
      ** Midas SF Menu Items Extract File                                                    BUG8922
                                                                                             BUG8922
     FSFMENUL2  IF   E           K DISK    INFSR(*PSSR)                                      BUG8922
      ** Midas SF Artificial menu codes                                                      BUG8922
                                                                                             BUG8922
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Local Data Area for Database Error Details
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** Menu Item Data Structure
     D WMenuItem       DS
     D  WPrefix                       2A
     D  WPage                         1A
     D  WHierID                       7A
 
      ***Data*Structure*for*User*Details*******************************               BUG8922 240985
     D*SDUser***     E DS                  EXTNAME(MUSERDD)                           BUG8922 240985
      *****************************************************************               BUG8922 240985
      ***DS*for*access*programs****************************************               BUG8922 240985
     D*DSSDY****     E DS                  EXTNAME(DSSDY)                             BUG8922 240985
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program Parameters
     D PRtCd           S              7A
     D PUser           S             12A
     D*PUserP***       S             10A                                              BUG8922 240985
 
      ** Key Fields
     D KUser           S                   LIKE(SFHUSR)
     D KMenu           S                   LIKE(SFHMSN)
     D KType           S                   LIKE(SFHMTP)
 
      ** Working Variables
     D WFound          S              1A
 
      ** +--------------------------------------+
      ** ¦ Prototype Declarations               ¦
      ** ¦ ======================               ¦
      ** +--------------------------------------+
 
      ** SPGetMenuItems Prototype
     D SPGetMenuItems  PR
     D  PHierID                            LIKE(SFLHID) VALUE
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------- Start of Main Processing -------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EXSR      SRMain
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Handles main processing.                            *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
 
     C                   EVAL      KUser = PUser
     C     KUser         CHAIN     SFMNUUL1
 
      ***If*the*given*user*is*not*found,*then*no*processing*is*necessary.                    BUG2975
      ** If the given user is not found, switch to the default menu.                         BUG2975
 
     C                   IF        NOT %FOUND
     C**********         EVAL      *INLR = *ON                                               BUG2975
     C**********         RETURN                                                              BUG2975
     C                   EVAL      KMenu = 'MAIN'                                            BUG2975
     C                   ELSE                                                                BUG2975
     C                   EVAL      KMenu = SFUMSN                                            BUG2975
     C                   ENDIF
 
     C                   EVAL      WFound = 'N'
     C**********         EVAL      KMenu = SFUMSN                                            BUG2975
     C                   EVAL      KType = 'TOP'
     C     KMNUH         SETLL     SFMNUHL1
     C     KMNUH         READE     SFMNUHL1
 
     C                   DOW       NOT %EOF
     C                   IF        SFHDLI <> 'Y'
     C                   EVAL      WFound = 'Y'
     C                   LEAVE
     C                   ENDIF
     C     KMNUH         READE     SFMNUHL1
     C                   ENDDO
 
      ** If no top menu is defined, then no processing is necessary.
 
     C                   IF        WFound = 'N'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   CALLP     SPGetMenuItems(SFHHID)
      *****************************************************************               BUG8922 240985
      ***Get*user's*security*level*************************************               BUG8922 240985
      *****************************************************************               BUG8922 240985
     C**********         Move      KUser         PUserP                               BUG8922 240985
     C**********         Call      'AOUSERR0'                                         BUG8922 240985
     C**********         Parm      *Blanks       PRtCd                                BUG8922 240985
     C**********         Parm      '*KEY'        POptn             7                  BUG8922 240985
     C**********         Parm                    PUserP                               BUG8922 240985
     C*****SDUser        Parm      SDUser        DSSDY                                BUG8922 240985
      *****************************************************************               BUG8922 240985
      ***Database*error************************************************               BUG8922 240985
      *****************************************************************               BUG8922 240985
     C**********         If        PRtCd <> *BLANKS                                   BUG8922 240985
     C**********         ExSr      *PSSR                                              BUG8922 240985
     C**********         EndIf                                                        BUG8922 240985
      *                                                                                      BUG8922
      ** Loop through any artificial menu codes (anything that doesn't                       BUG8922
      ** actually appear in a menu), and check against extract file and                      BUG8922
      ** security level.  If security level ok, and record not in extract                    BUG8922
      ** file, add it.                                                                       BUG8922
      *                                                                                      BUG8922
     C                   Read      SFMENUL2                                                  BUG8922
     C                   DoW       Not %EoF                                                  BUG8922
     C     MIINDX        Chain     SFMNUIL1                                                  BUG8922
     C                   If        Not %Found                                                BUG8922
     C                             and SECL >= MISECL                                        BUG8922
     C                   Eval      SFIMCD = MIINDX                                           BUG8922
     C                   Write     SFMNUID0                                                  BUG8922
     C                   EndIf                                                               BUG8922
     C                   Read      SFMENUL2                                                  BUG8922
     C                   EndDo                                                               BUG8922
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code
 
     C                   PARM                    PRtCd
 
      ** User
 
     C                   PARM                    PUser
      *                                                                                       240985
      ** User's security level                                                                240985
      *                                                                                       240985
     C                   PARM                    SECL              4 0                        240985
 
      ** Midas SF Menu Hierarchy File Key List
 
     C     KMNUH         KLIST
     C**********         KFLD                    KUser                                       BUG2975
     C                   KFLD                    KMenu
     C                   KFLD                    KType
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      PRtCd = '*ERROR '
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Subprocedure Definitions             ¦
      ** ¦ ========================             ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SPGetMenuItems - Gets menu items given a Hierarchy ID.       *
      *                                                               *
      *****************************************************************
     P SPGetMenuItems  B
     D SPGetMenuItems  PI
     D  PHierID                            LIKE(SFLHID) VALUE
 
      ** Key Fields
     D KHierID         S                   LIKE(SFLHID)
     D KLinkID         S                   LIKE(SFLLID)
 
      ** Working Variables
     D WHierIDn        S                   LIKE(SFLHID)
     D WLinkIDn        S                   LIKE(SFLLID)
 
      ** Midas SF Menu Links File Key List
 
     C     KMNUL         KLIST
     C                   KFLD                    KHierID
     C                   KFLD                    KLinkID
 
     C                   EVAL      KHierID = PHierID
     C     KHierID       SETLL     SFMNULL1
     C     KHierID       READE     SFMNULL1
 
     C                   DOW       NOT %EOF
 
     C                   EVAL      WMenuItem = SFLMCD
 
      ** Get menu items if the current menu code defines a submenu.
 
     C                   IF        WPrefix = '*S'
     C                   EVAL      WHierIDn = *ZERO
     C                   EVAL      WLinkIDn = *ZERO
     C                   EVALR     WHierID = %TRIM(WHierID)
     C                   MOVE      WHierID       WHierIDn
     C                   EVAL      WLinkIDn = SFLLID
     C                   CALLP     SPGetMenuItems(WHierIDn)
     C                   EVAL      KLinkID = WLinkIDn
     C     KMNUL         SETGT     SFMNULL1
     C                   ELSE
 
     C                   IF        SFLMCD <> *BLANKS
 
      ** At this point, the current menu code defines a menu item.
      ** Let's write it to the extract file.
 
     C                   EVAL      SFIMCD = SFLMCD
     C                   WRITE     SFMNUID0
     C                   ENDIF
 
     C                   ENDIF
 
     C     KHierID       READE     SFMNULL1
     C                   ENDDO
 
     C                   RETURN
 
     P                 E
