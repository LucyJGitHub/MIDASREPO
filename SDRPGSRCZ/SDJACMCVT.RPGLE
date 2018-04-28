     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Joint A/c Member Details Convert')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDJACMCVT - Midas SD Joint Account Member Details Convert    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244537             Date 17Aug05               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  244537 - To avoid overriding front office identifier         *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Standard D-specs
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Joint A/c Member Details - File Format
     D JAcMFilFmt    E DS                  EXTNAME(SDJACCPD)
 
      ** Joint A/c Member Details - Screen Format
     D JAcMScrFmt    E DS                  EXTNAME(SDJACMPD)
 
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRetCode        S             10A
     D PCvtMode        S              6A
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Convert Joint A/c Member details.
 
     C                   IF        PCvtMode = '*FILE '
     C                   EXSR      SRStoF
     C                   ELSE
     C                   EXSR      SRFtoS
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRStoF - Converts from screen format to file format.         *
      *                                                               *
      *****************************************************************
     C     SRStoF        BEGSR
 
     C                   CLEAR                   JAcMFilFmt
 
      ** Joint A/c Number
     C                   EVAL      JCJANO = DDJANO
 
      ** Customer Number
     C                   EVAL      JCCUST = DDCUST
 
      ** Non-a/c Holder
     C                   EVAL      JCNAHO = DDNAHO
 
      ** Investment Proportion
     C                   EVAL      JCINVP = DDINVP
 
      ** Prime A/c Holder for Tax Purposes
     C                   EVAL      JCPAHT = DDPAHT
 
      ** Prime A/c Holder
     C                   EVAL      JCPAHO = DDPAHO
                                                                                              244537
      ** Front Office Transaction ID                                                          244537
     C                   EVAL      JCFRNT = DDFRNT                                            244537
                                                                                              244537
      ** Repair Location                                                                      244537
     C                   EVAL      JCREPA = DDREPA                                            244537
 
      ** Type of Last Change
     C                   EVAL      JCCHTP = DDACTN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFtoS - Converts from file format to screen format.         *
      *                                                               *
      *****************************************************************
     C     SRFtoS        BEGSR
 
     C                   CLEAR                   JAcMScrFmt
 
      ** Joint A/c Number
     C                   EVAL      DDJANO = JCJANO
 
      ** Customer Number
     C                   EVAL      DDCUST = JCCUST
 
      ** Non-a/c Holder
     C                   EVAL      DDNAHO = JCNAHO
 
      ** Investment Proportion
     C                   EVAL      DDINVP = JCINVP
 
      ** Prime A/c Holder for Tax Purposes
     C                   EVAL      DDPAHT = JCPAHT
 
      ** Prime A/c Holder
     C                   EVAL      DDPAHO = JCPAHO
                                                                                              244537
      ** Front Office Transaction ID                                                          244537
     C                   EVAL      DDFRNT = JCFRNT                                            244537
                                                                                              244537
      ** Repair Location                                                                      244537
     C                   EVAL      DDREPA = JCREPA                                            244537
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      **********************
      ** Input Parameters **
      **********************
 
      ** Return Code
     C                   PARM                    PRetCode
 
      ** Convert Mode
     C                   PARM                    PCvtMode
 
      ***********************
      ** Output Parameters **
      ***********************
 
      ** Joint A/c Member Details - File Format
     C                   PARM                    JAcMFilFmt
 
      ** Joint A/c Member Details - Screen Format
     C                   PARM                    JAcMScrFmt
 
      **---------------------------------------------------------------
      ** Program, Module, & Procedure Names for DB Error Processing
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** ILE RPG Program Status Subroutine
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2004
