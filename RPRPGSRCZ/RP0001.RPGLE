     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP Controller for features Initialisation')
      *****************************************************************
      *                                                               *
      *  Meridian DBA Replication                                     *
      *                                                               *
      *  RP0001 - Midas RP Controller for Features Initialisation.    *
      *                                                               *
      * This program is called by RPC0001. It will initialise the     *
      *  Replication filter file when feature is being turn ON or     *
      *  turn OFF.
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CPL005  *CREATE    Date 16Jan01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CPL005 - Midas-Plato Real-time Interface.                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    80 - End of records for key on PF/MDBASCRIPT               *
      *    U7 - Error encountered in processing                       *
      *    LR - Last Record - End program                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FRPSFINPD  IF   E             DISK
     FMDBASCRIPTUF   E             DISK    RENAME(MDBASCRIPT:MSCRIPTDF)
 
      /EJECT
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
 
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
 
     D A_Filter        S             32A   DIM(100)
     D A_ChgValue      S              1A   DIM(100)
     D A_Data          S              1A   DIM(100)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Indx            S              3  0
     D Filter_Tag      S              8A   INZ('<FILTER>')
     D Filter_Name     S             32A
     D Chg_Value       S              1A
     D Type_Tag        S              6A   INZ('<TYPE>')
     D Fd_Pos          S              7  0
     D Scan_Pos        S              7  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
 
      ** +--------------------------------------+
      ** ¦ Start F-specs                        ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** Build up array for Filter from PF/RPSFINPD
      *
     C                   EVAL      Indx = 1
     C                   EVAL      *IN34 = '0'
      *
      ** Read RPSFINPD until EOF and Array is not full
      *
     C     *IN34         DOWEQ     '0'
     C     Indx          ANDLT     101
 
     C                   READ      RPSFINPD                             3434
      *
      ** If not EOF, add filter name and change to value to array
      *
     C     *IN34         IFEQ      '0'
     C     RPCGFT        ANDEQ     'Y'
     C                   EVAL      Indx = Indx +1
     C                   EVAL      A_Filter(Indx) = RPFLTR
     C                   EVAL      A_ChgValue(Indx) = RPCGTO
     C                   ENDIF
 
     C                   ENDDO
      *
      ** Only process initialisation process if there is Filter type need
      ** to be changed.
      *
     C                   IF        Indx <> 0
 
     C                   EVAL      *IN80 = '0'
      *
      ** Read in Script file until EOF
      *
     C     *IN80         DOWEQ     '0'
 
     C                   READ      MDBASCRIPT                           8080
      *
      ** If not EOF
      *
     C                   IF        *IN80 = '0'
      *
      ** Get Filter Name by looking for tag '<FILTER>'.
      *
     C     Filter_Tag    SCAN      SRCDTA:1      Scan_Pos
 
     C                   IF        Scan_Pos <> 0
     C                   EVAL      Fd_Pos = Scan_Pos + 8
     C                   SUBST     SRCDTA:Fd_Pos Filter_Name
      *
      ** Check if the filter type need to be change
      *
     C                   EVAL      Indx = 1
     C     Filter_Name   LOOKUP    A_Filter(Indx)                         21          ,
 
     C                   IF        *IN21 = '1'
 
     C                   EVAL      Chg_Value = A_ChgValue(Indx)
      *
      ** Get the Filter Type record
      *
     C                   READ      MDBASCRIPT                           8080
 
     C                   IF        *IN80 = '0'
 
     C     Type_Tag      SCAN      SRCDTA        Scan_Pos
 
     C                   IF        Scan_Pos <> 0
      *
      ** If Filter Type reord found
      *
      ** If Mode = '3' then change the value back as before
      *
     C                   IF        Run_Mode = '3'
 
     C                   IF        Chg_Value = 'C'
     C                   EVAL      Chg_Value = 'B'
     C                   ELSE
     C                   EVAL      Chg_Value = 'C'
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Change Filter Type Value
      *
     C                   EVAL      Fd_Pos = Scan_Pos + 6
     C                   MOVEA     SRCDTA        A_Data
     C                   MOVE      Chg_Value     A_Data(Fd_Pos)
     C                   MOVEA     A_Data        SRCDTA
     C                   UPDATE    MSCRIPTDF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
 
 
     C                   Seton                                        LR
     C                   Return
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
 
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
 
     C                   SETON                                        U7U8LR
     C                   RETURN
 
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** Mode
     C                   PARM                    Run_Mode          1
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
