     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cashier TCP/IP listener program')
      *****************************************************************
      *                                                               *
      *  Midas - Cashier Interface Module                             *
      *                                                               *
      *  RE004500 - Midas Cashier TCP/IP Listener program             *
      *                                                               *
      *  Function:  This program is listener program in charge to     *
      *             listen for incoming TCP/IP connection request     *
      *             When connection established, a worker process is  *
      *             submitted.                                        *
      *  Author: Alain Differdange                                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *  Prev Amend No. 194002             Date 06Jul01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CRT004  *CREATE    Date 02Jun00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  194002 - Multiple Jobs issue.  Use REC4590 to end all branch *
      *           jobs if an error occurs.                            *
      *  CRT004 - Cashier Midas TCP/IP interface.                     *
      *                                                               *
      *****************************************************************
     F/EJECT
      *
      *
     D/EJECT
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
 
      * Compile-time arrays to hold message types and associated jobs
     D TABTYP          S              3    DIM(4) CTDATA PERRCD(1)
     D TABJOB          S             10    DIM(4) alt(TABTYP)
      *
      *  Program data structure
      *
     D DSPGM         ESDS                  EXTNAME(Y2PGDSP)
      *
      *  Send message data structure
      *
     D DBDTA           DS
     D  DBPGM                  1     10
     D  DBFILE                11     20
     D  DBKEY                 21     50
     D  DBERNB                51     55  0
     D  DBNARR                56    135
     D  DBSTK                136    145
     D  DBPREF               146    175
      *
      *
      * Prototype Definitions
      *
 
     D opn_tcp         pr            10i 0
 
     D bnd_tcp         pr            10i 0
     d                               10i 0 Const
     d                               10i 0 Const
     d                               10i 0 Const
     d                                 *
     d                               10i 0
 
     D lst_tcp         pr            10i 0
     d                               10i 0 Const
     d                               10i 0 Const
     d                                 *
     d                               10i 0
 
     D con_tcp         pr            10i 0
     d                               10i 0 Const
     d                               30
     d                                2  0 Const
     d                                4  0 Const
 
     D snd_tcp         pr            10i 0
     d                               10i 0 Const
     d                               50
 
     D rcv_tcp         pr            10i 0
     d                               10i 0 Const
     d                               50
 
     D cls_tcp         pr            10i 0
     d                               10i 0 Const
 
     D give_Ds         pr            10i 0
     d                               20
     d                               10i 0 Const
 
     D Get_Jobint      pr            16
 
      * Other variables
     D Port            S              4  0
     D JobintSRC       S             16
     D JobintTGT       S             16
     D ScktNum         S             10I 0
     D ClnSkt          S             10I 0
     D RetCode         S             10I 0
     D Str             S           9911
     D giveret         S             10I 0
     D addr            S               *
     D size            S             10I 0
 
      /COPY ZSRSRC,RBEQENI2LE
 
     I/EJECT
      *
      * Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   END
      *
     C                   EXSR      SRMAIN
      *
      * Return to calling program
      *
     C                   RETURN
      *
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRMAIN   :                                                   *
      *                                                               *
      *  CALLED BY:                                                   *
      *                                                               *
      *  CALLS    :                                                   *
      *                                                               *
      *****************************************************************
     CSR   SRMAIN        BEGSR
      * Open the socket
     C                   Eval      ScktNum = Opn_Tcp
     C                   If        ScktNum = -1
     C                   exsr      *pssr
     C                   EndIf
 
      * Bind/listen/accept
     C                   Eval      RetCode = Bnd_Tcp( ScktNum: port: 512: addr:
     C                                                size)
     C                   If        RetCode = -1
     C                   exsr      *pssr
     C                   EndIf
      * Loop to receive messages
     c     1             doweq     1
      *
     c                   exsr      SRMSG
      *
     c                   enddo
      *
     CSR   SRMAINX       ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : SRERR  - report errors                            *
      *                                                               *
      *****************************************************************
     CSR   SRINIT        BEGSR
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      *  Define entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    BRC               3
     C                   PARM                    porta             4
      *
     C                   MOVEL     porta         port
      *
      *  Indicate that set up is complete
      *
     C                   SETON                                        50
      *
     c                   EVAL      jobintSRC = Get_Jobint
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRMSG    :                                                   *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    :                                                   *
      *                                                               *
      *****************************************************************
     CSR   SRMSG         BEGSR
      *
     C                   Eval      RetCode = Lst_Tcp( ScktNum: 512: addr:
     C                                                size)
     C                   If        RetCode = -1
      * Listen Failure
     C                   exsr      *pssr
     C                   EndIf
     C                   eval      ClnSkt = RetCode
      * Receive
     C                   Eval      RetCode = Rcv_Tcp( ClnSkt: Str )
     C                   If        RetCode = -1
      * Receive Failure
     C                   exsr      *pssr
     C                   else
     c                   eval      msgtyp= %subst(str:9:3)
     c                   eval      unit= %subst(str:12:3)
     c                   eval      jobuser= %subst(str:15:10)
     c                   eval      brc4= %subst(str:25:4)
      *
     C     msgtyp        lookup    TABTYP        TABJOB                   09
     C                   if        *IN09 = *ON
     c* submit job (with dataq name?)
     C                   callb     'REC004500'
     c                   parm                    JobintSRC
     c                   parm                    brc4              4
     c                   parm                    jobuser          10
     c                   parm                    unit              3
     c                   parm                    msgtyp            3
     c* wait to get jobs ID from dataq, then pass it descriptor.
     c                   eval               P@QRC = 'RE4500' + brc              DataQ Name
     c                   eval               P@QLR ='*LIBL'                      DataQ Library
     c                   eval               P@QTM = 180                         DataQ Timeout
     C                   EXSR      RDQMS
     c                   eval      JobintTGT = %subst(P@QDR:1:16)
     c                   movel(P)  JobintTGT     jobintlong       20
     c                   eval      giveret = give_ds( jobintlong: clnskt )
     c                   if        giveret = -1
      * Do not Stop Listener in case of error and loop for listening to new requests
      * Call REC4590 to perform an ENDJOB for the worker jobs.                                194002
     C                   call      'REC4590'                                                  194002
     c                   parm                    BRC                                          194002
     c                   endif
      * Close the client socket as it has been given to the worker
     C                   eval      RetCode = Cls_Tcp( clnskt )
     c                   else
      * Unknown message
     c                   exsr      *pssr
     C                   EndIf
     C                   EndIf
 
      *
     CSR   SRMSGX        ENDSR
     C/EJECT
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
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
      * Close the Listener socket has it benn given to the worker
     C                   eval      RetCode = Cls_Tcp( Scktnum )
     C                   SETON                                        U7U8LR
     C                   return
      *
     C                   ENDSR
      *
      ********************************************************************
      *
      /EJECT
      /COPY ZSRSRC,RBRDQMSLE
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA TABTYP
BOGREC4502
COGREC4501
FOGREC4503
MOGREC4505
