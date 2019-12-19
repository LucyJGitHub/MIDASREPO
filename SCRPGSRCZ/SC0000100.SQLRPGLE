     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                     AR989143
/*STD *  RPGSQLBND                                                    *                     AR989143
/*EXI *  TEXT('Midas SC Selection convert code to call')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC0000100 - Option Selection Processing                      *
      *                                                               *
      *  Function:  This program calls AOMENUR0 Access Object to get  *
      *  the call parameters                                          *
      *                                                               *
      *  Called By: SCC0000100 - Option Selection Screen              *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. CCB020             Date 06Aug12               *
      *                 AR989143           Date 13Jun12               *
      *                 CBF005             Date 04Jul11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243475             Date 26Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 235634             Date 11Oct06               *
      *                 241861             Date 01Sep06               *
      *                 BUG11755           Date 24Jul06               *
      *                 BUG9969            Date 12Jan06               *
      *                 BUG2287            Date 28Apr04               *
      *                 CAAA02  *CREATE    Date 06Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *         - Add additional checking if action is allowed in     *
      *           Phase G                                             *
      *  AR989143 - Enhancement of SC0000100 at BFM 2.0. This is the  *
      *             BF platform equivalent of AR866401.               *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *  243475 - Applied fix 243665 from 1.2T                        *
      *  243665 - File locks in CoB                                   *
      *  235634 - Recompiled due to changes in GZMACBRL2              *
      *  241861 - Skip BUG9969.                                       *
      *  BUG11755 - Unable to call global menu items in green screen. *
      *  BUG9969- Menu Item Security                                  *
      *  BUG2287- Show consolidated global view  (Recompile)          *
      *  CAAA02 - Webfacing Enhancement                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *    99         Found Action Code Record                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     F**MACBR***  IF A E           K DISK                                             BUG9969 CBF005
     F**GZMACBRL2 IF*A*E******     K DISK    RENAME(MACBRDDF:GZMACBRDDF)              BUG9969 CBF005
     F**********                             PREFIX(G_)                               BUG9969 CBF005
     F**GPMACBR*  IF   E           K DISK    RENAME(MACBRDDF:GPMACBRDDF)             BUG11755 CBF005
     F**********                             PREFIX(H_)                              BUG11755 CBF005

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D PermCount       S              4  0                                                  AR989143
     D SysValue        S            200                                                     AR989143
     D ZoneName        S             10                                                     AR989143
      *                                                                                     AR989143
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D*RUNDAT***     E DS                  EXTNAME(RUNDAT)                                  AR989143
      *
      ** Data Area giving Installation Control Details

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     DDSSDY          E DS
     DMENU           E DS                  EXTNAME(SFMENUPD)

     DZMITEM         E DS                  EXTNAME(ZMITEM)

     DGrpCode          DS
     D Group                   1      4  0
     D Code                    5      8

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     D WFSEL           S             10
     D UniqueID        S             10
     D RtnCall         S            100
     D Mphas           S              1                                                       CCB020
     D ReturnCode      S              7
     D Option          S              7
     D Parms           S             80
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

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Read in Installation Data
      *
     C******DTAARA       DEFINE                  RUNDAT                                     AR989143
     C     *DTAARA       DEFINE                  LDA
     C**********         IN        RUNDAT                                                   AR989143
      *
      ***Set*Date*Format*Indicator**IN98**on*if*date*format*is*MMDDYY**                     AR989143
      *
     C**********         IF        AGDFF = 'M'                                              AR989143
     C**********         EVAL      *IN98 = *ON                                              AR989143
     C**********         END                                                                AR989143

     C                   Eval      UniqueID = WFSEL
     C                   Eval      Option = '*KEY'

     C                   CALL      'AOMENUR0'
     C                   PARM                    ReturnCode                     B:Return code
     C                   PARM                    Option                         I:Option
     C                   PARM                    UniqueID                       I:UniqueID
     C     MENU          PARM      MENU          DSSDY                          O:Format
     C*
                                                                                              243665
      * Unlock SFMENUPD                                                                       243665
     C                   CALL      'AOMENUR0'                                                 243665
     C                   PARM                    ReturnCode2       7            B:Return code 243665
     C                   PARM      '*FREE'       Option                         I:Option      243665
     C                   PARM                    UniqueID                       I:UniqueID    243665
     C                   PARM                    DSSDY                          O:Format      243665
      *                                                                                       243665
     C                   If        ReturnCode <> *Blanks
      *
      ** Data base error in file (file)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SFMENUL0'
     C                   EVAL      DBKEY  =  'UniqueID'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'Main'
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   Endif
      *                                                                                       CCB020
      ** Check MPHAS for phase G and if action is valid to run                                CCB020
      ** in this phase.                                                                       CCB020
      *                                                                                       CCB020
     C                   IF        Mphas = 'G' AND MIACOB = 'Y'                               CCB020
     C                   EVAL      RtnCall = 'G'                                              CCB020
     C                   EVAL      *INLR = *ON                                                CCB020
     C                   RETURN                                                               CCB020
     C                   ENDIF                                                                CCB020
      *                                                                                     AR989143
      ** Retrieve zone name from System Value file                                          AR989143
      *                                                                                     AR989143
     C/EXEC SQL                                                                             AR989143
     C**select*GIVAL into :SysValue from SDSVALPD                                  AR989143 MD054605
     C+ Declare Cursor1 Insensitive scroll cursor for                                       MD054605
     C+ select GIVAL from SDSVLJW0                                                          MD054605
     C+ where GISVAL = 'ZoneSystemName'                                                     AR989143
     C/END-EXEC                                                                             AR989143
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor1                                                                        MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor1 INTO :SysValue                                              MD054605
     C/END-EXEC                                                                             MD054605
      *                                                                                     AR989143
     C/EXEC SQL                                                                             MD054605
     C+ Close Cursor1                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C                   IF        SysValue = *BLANKS                                       AR989143
     C     *LOCK         IN        LDA                                                      AR989143
     C                   EVAL      *INU7 = *ON                                              AR989143
     C                   EVAL      *INU8 = *ON                                              AR989143
     C                   EVAL      DBFILE =  'SDSVALPD'                                     AR989143
     C                   EVAL      DBKEY  =  'ZoneSystemName'                               AR989143
     C                   EVAL      DBPGM  =  PSProcPgm                                      AR989143
     C                   EVAL      DBASE  =  002                                            AR989143
     C                   EVAL      DBMOD  =  PSProcMod                                      AR989143
     C                   EVAL      DBPROC =  'Main'                                         AR989143
     C                   OUT       LDA                                                      AR989143
     C                   EXSR      *PSSR                                                    AR989143
     C                   ELSE                                                               AR989143
     C                   EVAL      ZoneName = %TRIM(SysValue)                               AR989143
     C                   ENDIF                                                              AR989143
      *                                                                                     AR989143
      **********                                                                      BUG9969 CBF005
      ***Check*that*user*is*has*at*least*one*action*code*allowed*on*this*item         BUG9969 CBF005
      **********                                                                      BUG9969 CBF005
     C*****UsrKey        SETLL     MACBR                                              BUG9969 CBF005
     C*****UsrKey        READE     MACBR                                  99          BUG9969 CBF005
     C******IN99         IFEQ      *OFF                                               BUG9969 CBF005
     C*****ACA1*         IFEQ      *BLANK                                             BUG9969 CBF005
     C**********         EVAL      *IN99 = *ON                                        BUG9969 CBF005
     C**********         ENDIF                                                        BUG9969 CBF005
     C**********         ENDIF                                                        BUG9969 CBF005
     C******IN99         IFEQ      *ON                                                BUG9969 CBF005
     C*****UsrKey        SETLL     GZMACBRL2                                          BUG9969 CBF005
     C*****UsrKey        READE     GZMACBRL2                              99          BUG9969 CBF005
     C******IN99         IFEQ      *OFF                                               BUG9969 CBF005
     C*****G_ACA1        IFEQ      *BLANK                                             BUG9969 CBF005
     C**********         EVAL      *IN99 = *ON                                        BUG9969 CBF005
     C**********         ENDIF                                                        BUG9969 CBF005
     C**********         ENDIF                                                        BUG9969 CBF005
     C**********         ENDIF                                                        BUG9969 CBF005
     C******IN99         IFEQ      *ON                                               BUG11755 CBF005
     C*****UsrKey        SETLL     GPMACBR                                           BUG11755 CBF005
     C*****UsrKey        READE     GPMACBR                                99         BUG11755 CBF005
     C******IN99         IFEQ      *OFF                                              BUG11755 CBF005
     C*****H_ACA1        IFEQ      *BLANK                                            BUG11755 CBF005
     C**********         EVAL      *IN99 = *ON                                       BUG11755 CBF005
     C**********         ENDIF                                                       BUG11755 CBF005
     C**********         ENDIF                                                       BUG11755 CBF005
     C**********         ENDIF                                                       BUG11755 CBF005
      *                                                                                      BUG9969
      *                                                                                     AR989143
     C/EXEC SQL                                                                             AR989143
     C+ select count(*) into :PermCount from MIVW_PERMM                                     AR989143
     C+ where                                                                               AR989143
     C+     USRP = :PSUSER                                                                  AR989143
     C+ and INDX = :WFSEL                                                                   AR989143
     C+ and ZONE = :ZoneName                                                                AR989143
     C/END-EXEC                                                                             AR989143
      *                                                                                     AR989143
     C******IN99         IFEQ      *OFF                                               BUG9969 241861
     C                   IF        PermCount > 0                                            AR989143
     C                   Eval      RtnCall = MIPATH
     C                   ENDIF                                                              AR989143
     C**********         ENDIF                                                        BUG9969 241861
     C     *DTAARA       DEFINE                  ZMITEM
     C     *LOCK         IN        ZMITEM
     C                   EVAL      INDX = MIINDX
     C                   OUT       ZMITEM

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *entry        PLIST
     C                   PARM                    WFSEL
     C                   PARM                    RtnCall
     C                   PARM                    Mphas                                        CCB020

     C*****UsrKey        KLIST                                                        BUG9969 CBF005
     C**********         KFLD                    PSUSER                               BUG9969 CBF005
     C**********         KFLD                    WFSEL                                BUG9969 CBF005
                                                                                             BUG9969
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
