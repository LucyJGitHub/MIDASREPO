     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MG Format Field 25 ')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation Module                            *
      *                                                               *
      *  MGFLD25  - Format Account                                    *
      *                                                               *
      *  Function:  This program formats the Account according to the *
      *             system values.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2019                      *
      *                                                               *
      *  Last Amend No. MD055057           Date 13Jan20               *
      *  Prev Amend No. CMG006  *Create    Date 15Oct19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055057 - Field tag 25 output is wrong in 2 different       *
      *             scenarios.                                        *
      *  CMG006 - MT940, 941, 942 & 950 Field 25 Account              *
      *           Identification.                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                              *
      *  U7 U8 LR                                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR        - Program Initialisation routine               *
      *                                                               *
      *****************************************************************
     FACCNTL1   IF   E           K DISK
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
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
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access objects - short data structure
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(Sc_)
      **  External data structures for Switchable Features Details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access objects - long data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WPACNO                              LIKE(ACNO)
     D P@SARD          S              6A
     D ACFMTPGM        S             10A
     D Yes             S              1A   INZ('Y')
     D FldPrefix       S             20    INZ('MT94xFld25Prefix')
     D FldCcy          S             20    INZ('MT94xFld25Ccy')
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Process Main.
 
     C                   EXSR      SRMain
 
      ** End the program
 
     C                   EXSR      SREnd
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Main Processing                                     *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
 
     C                   IF        PCCY = *BLANK
     C                   Move      PACNO         WPACNO
 
     C     WPACNO        CHAIN     ACCNTABF                           99
 
     C                   IF        *IN99 = *OFF
     C                   Eval      PCCY  = CCY
     C                   Endif
 
     C                   Endif
     
     C**********         IF        WBRCH <> *BLANKS and  WCCYRQ =  Yes                      MD055057
     C**********         Eval      PACCID = (WBRCH + PCCY + PACNO)                          MD055057
     C**********         ELSE                                                               MD055057
     C**********         Eval      PACCID =  PACNO                                          MD055057
     C**********         Endif                                                              MD055057
                                                                                            MD055057
     C                   IF        WBRCH <> *BLANKS                                         MD055057
     C                   If        WCCYRQ =  Yes                                            MD055057
     C                   Eval      PACCID = (WBRCH + PCCY + PACNO)                          MD055057
     C                   Else                                                               MD055057
     C                   Eval      PACCID = (WBRCH + PACNO)                                 MD055057
     C                   Endif                                                              MD055057
     C                   ELSEIF    WCCYRQ =  Yes                                            MD055057
     C                   Eval      PACCID = (PCCY + PACNO)                                  MD055057
     C                   ELSE                                                               MD055057
     C                   Eval      PACCID =  PACNO                                          MD055057
     C                   ENDIF                                                              MD055057
 
     C                   ENDSR
      *****************************************************************
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
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
      * Check system values
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD             7
     C                   PARM      FldPrefix     SVALK1           20
     C                   PARM                    SVAL1           200
     C                   PARM      FldCcy        SVALK2           20
     C                   PARM                    SVAL2           200
     C                   PARM      *BLANK        SVALK3           20
     C                   PARM                    SVAL3           200
     C                   PARM      *BLANK        SVALK4           20
     C                   PARM                    SVAL4           200
     C                   PARM      *BLANK        SVALK5           20
     C                   PARM                    SVAL5           200
     C                   PARM      *BLANK        SVALK6           20
     C                   PARM                    SVAL6           200
     C                   PARM      *BLANK        SVALK7           20
     C                   PARM                    SVAL7           200
     C                   PARM      *BLANK        SVALK8           20
     C                   PARM                    SVAL8           200
     C                   PARM      *BLANK        SVALK9           20
     C                   PARM                    SVAL9           200
     C                   PARM      *BLANK        SVALK0           20
     C                   PARM                    SVAL10          200
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     FldPrefix     DBKEY
     C                   MOVEL     'SDSVALPD'    DBFILE                           ***************
     C                   MOVEL     '001'         DBASE                            * DBERROR 001 *
     C                   SETON                                        U7U8        ***************
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   MOVEL     SVAL1         WBRCH             4            Branch Prefix.
     C                   MOVEL     SVAL2         WCCYRQ            1            CCY Required Y/N ?
 
     C                   ENDIF
 
     C     *Entry        Plist
     C
     C                   Parm                    PCCY              3
     C                   Parm                    PACNO            10
     C                   Parm                    PACCID           35
     C
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      *                                                               *
      * SREND  - Subroutine to End Program                            *
      *                                                               *
      *****************************************************************
 
     C     SREND         BEGSR
      *
      *  End program
     C                   Seton                                        LR
     C                   Return
 
     C                   Endsr
      *****************************************************************
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
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EXSR      SREnd
 
     C                   ENDSR
      ********************************************************************
